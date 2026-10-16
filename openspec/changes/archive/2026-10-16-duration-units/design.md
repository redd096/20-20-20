# Design

## Context

Le impostazioni stanno in un `ConfigurationGroup` in `/apps/harbour-202020` (`qml/harbour-202020.qml`): `workMinutes` (1–120), `breakSeconds` (5–300) e `testWorkSeconds`, che se maggiore di 0 sostituisce la durata del lavoro. `CycleController` riceve già entrambe le durate in secondi, con un clamp nel binding.

`StepSlider` legge `initialValue` una sola volta, in `Component.onCompleted`, e non ha un binding con dconf. È una scelta voluta, perché le notifiche asincrone di dconf riportavano lo slider a valori vecchi. Per questo un cambio di modalità con la pagina aperta non aggiorna da solo gli slider.

Il riferimento per nomi ed etichette è l'app Orologio di Jolla (`ClockEditDialog.qml`): `ComboBox` «Units», voci «Hours and minutes» / «Minutes and seconds», enum `TimePickerMode.HoursAndMinutes` / `MinutesAndSeconds`. Jolla non salva la modalità, la ricava dalla durata. Qui va salvata, perché «Minuti e minuti» non si può ricavare dai valori.

## Goals / Non-Goals

**Goals:**
- Un'unica unità di misura (secondi) per le durate salvate e per il controller.
- Lasciare invariati `StepSlider` e `CycleController`, già verificati.

**Non-Goals:**
- Migrare i valori di `workMinutes` già salvati.
- Ricordare le durate scelte in ciascuna modalità.

## Decisions

### D1. Chiavi dconf: durate in secondi più la modalità
`durationUnits` (stringa: `minutesAndSeconds` predefinito, `minutesAndMinutes`, `secondsAndSeconds`), `workSeconds` (predefinito 1200), `breakSeconds` (predefinito 20). Spariscono `workMinutes` e `testWorkSeconds`. `breakSeconds` mantiene nome e significato.
- La modalità serve solo a mostrare e scegliere i valori; il controller legge sempre secondi, senza moltiplicazioni legate alla modalità.
- I valori sono stringhe in CamelCase come l'enum di Jolla, non l'indice del menu, come già per `alertType` e `alertRepeat`: riordinare le voci non invalida le impostazioni salvate.
- Alternativa scartata: chiavi nell'unità della modalità (`workValue` in minuti o secondi). Costringerebbe controller e clamp a conoscere la modalità.

### D2. Intervalli per unità, non per modalità
Ogni slider ha un'unità derivata dalla modalità: in minuti va da 1 a 60 con passo 1, in secondi da 5 a 120 con passo 5. Lo slider in minuti mostra `secondi / 60` e salva `valore * 60`. Basta quindi una piccola tabella con due voci (minuti, secondi) invece di una per modalità.
- Alternativa scartata: intervalli diversi per modalità (per esempio pausa 1–30 min in «Minuti e minuti»). Meno coerente e più dati da mantenere.

### D3. Cambio di modalità: predefiniti e slider ricreati
Quando l'utente sceglie nel `ComboBox` una modalità diversa da quella salvata, si scrivono `durationUnits` e i predefiniti della nuova modalità (20 min / 20 s, 25 min / 5 min, 20 s / 20 s), poi si ricreano i due slider con un `Loader` (si cambia il `sourceComponent` o lo si azzera e si ripristina). Gli slider nuovi leggono il proprio `initialValue` dai valori appena scritti in memoria, quindi non aspettano la notifica di dconf. Se la modalità scelta è già quella attiva non si fa nulla.
- Alternativa scartata: una funzione `reset(value)` in `StepSlider`. Toccherebbe un componente già verificato.

### D4. Clamp in base all'unità
In `harbour-202020.qml` il binding verso `CycleController` blocca le durate ai limiti dell'unità della modalità attiva (60–3600 s per i minuti, 5–120 s per i secondi), per difendersi da valori modificati a mano in dconf. Un valore salvato non multiplo di 60 in una modalità in minuti viene arrotondato al minuto dallo slider alla prima modifica; il controller usa il valore com'è.

### D5. Nessuna migrazione
L'app è installata solo sul telefono dell'autore. Dopo l'installazione della nuova release si lancia `dconf reset -f /apps/harbour-202020/`. La vecchia chiave `workMinutes`, se non viene cancellata, resta in dconf inutilizzata. La procedura va in `docs/sailfish.md`, insieme all'elenco delle chiavi aggiornato e alla prova con «Secondi e secondi» al posto di `testWorkSeconds`.

## Risks / Trade-offs

- [Il `ComboBox` di Silica lancia `onClicked` anche quando viene riselezionata la voce attiva] → Si salva in `MenuItem.onClicked`, come gli altri menu della pagina (l'indice iniziale impostato in `Component.onCompleted` quindi non scrive nulla), con un confronto esplicito con `durationUnits` prima di scrivere i predefiniti.
- [Il cambio di modalità durante una fase in corso] → Vale la regola esistente: le durate si applicano dalla fase successiva.
- [Durate prima consentite (lavoro oltre 60 min, pausa oltre 120 s) non lo sono più] → Accettato; con «Minuti e minuti» la pausa arriva a 60 min.
