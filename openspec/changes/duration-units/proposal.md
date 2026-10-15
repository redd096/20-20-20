# Proposal

## Why

Oggi le durate hanno unità fisse: lavoro in minuti (1–120) e pausa in secondi (5–300). Vanno bene per la regola 20-20-20, ma non per chi vuole usare l'app con pause più lunghe, alla Pomodoro. In più, per le prove sul telefono serve la chiave nascosta `testWorkSeconds`, modificabile solo da dconf. Un selettore delle unità, come quello dell'app Orologio di Sailfish quando si crea un timer («Ore e minuti» / «Minuti e secondi»), copre tutti e tre i casi con un solo controllo visibile.

## What Changes

- Nuova impostazione «Units» / «Unità» (menu a tendina, sopra gli slider delle durate) con tre valori:
  - «Minutes and seconds» / «Minuti e secondi»: lavoro in minuti, pausa in secondi. È il comportamento attuale e resta il predefinito.
  - «Minutes and minutes» / «Minuti e minuti»: lavoro e pausa in minuti, come in Minidoro.
  - «Seconds and seconds» / «Secondi e secondi»: lavoro e pausa in secondi. Utile a chi vuole cicli brevissimi, e per le prove.
- Regola unica per gli slider, uguale in ogni modalità: in minuti vanno da 1 a 60 con passo 1, in secondi da 5 a 120 con passo 5.
- Valori predefiniti per modalità: 20 min / 20 s, 25 min / 5 min, 20 s / 20 s.
- Quando l'utente sceglie una modalità diversa da quella attiva, lavoro e pausa tornano ai predefiniti della nuova modalità. Nessuna conversione dei valori.
- **BREAKING**: gli intervalli si restringono (lavoro da 1–120 a 1–60 min, pausa da 5–300 a 5–120 s), cambiano le chiavi dconf delle durate e viene rimossa la chiave nascosta `testWorkSeconds`, sostituita dalla modalità «Secondi e secondi». Nessuna migrazione: l'app è installata solo sul telefono dell'autore, basta un `dconf reset`.

Fuori scope: ore come unità, durate diverse per cicli successivi (pausa lunga del Pomodoro), preset con nome.

## Capabilities

### New Capabilities
<!-- Nessuna. -->

### Modified Capabilities
- `break-cycle`: cambia il requisito «Durate configurabili» (modalità delle unità, intervalli per unità, predefiniti per modalità, ritorno ai predefiniti al cambio di modalità).

## Impact

- `project_sailfish_os/qml/pages/SettingsPage.qml`: menu delle unità, slider che si adattano all'unità. `StepSlider.qml` non cambia.
- `qml/harbour-202020.qml`: chiavi dconf `durationUnits`, `workSeconds`, `breakSeconds`; rimosse `workMinutes` e `testWorkSeconds`; clamp in base all'unità.
- `CycleController.qml` non cambia: riceve già le durate in secondi.
- Traduzioni: nuove stringhe in inglese e italiano.
- `docs/sailfish.md`: elenco delle chiavi dconf e procedura di prova senza `testWorkSeconds`.
- Nessuna nuova dipendenza.
