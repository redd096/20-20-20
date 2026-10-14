# Proposal

## Why

Oggi le durate hanno unità fisse: lavoro in minuti (1–120) e pausa in secondi (5–300). Vanno bene per la regola 20-20-20, ma non per chi vuole usare l'app con pause più lunghe, alla Pomodoro. In più, per le prove sul telefono serve la chiave nascosta `testWorkSeconds`, modificabile solo da dconf. Un selettore delle unità, come quello dell'app Orologio di Sailfish quando si crea un timer («Ore e minuti» / «Minuti e secondi»), copre tutti e tre i casi con un solo controllo visibile.

Da fare dopo l'archiviazione di `sailfish-mvp`, su una base già verificata.

## What Changes

- Nuova impostazione «Unità delle durate» (menu a tendina) con tre valori:
  - «Minuti e secondi»: lavoro in minuti, pausa in secondi. È il comportamento attuale e resta il predefinito.
  - «Minuti e minuti»: lavoro e pausa in minuti, come in Minidoro.
  - «Secondi e secondi»: lavoro e pausa in secondi. Utile a chi vuole cicli brevissimi, e per le prove.
- Gli slider delle durate cambiano unità, etichette e intervallo in base alla modalità scelta.
- Da decidere nella design: cosa succede alle durate salvate quando l'utente cambia modalità (conversione, valori predefiniti per modalità, o un valore salvato per ogni modalità).
- Da valutare nella design: se gli intervalli attuali (lavoro 1–120 min, pausa 5–300 s) sono troppo lunghi per uno slider comodo. Per esempio Minidoro usa 1–60 min per il lavoro e 1–30 min per la pausa, con passo 1. Scegliere minimo, massimo e passo per ogni modalità.
- **BREAKING** (solo per le prove): rimossa la chiave nascosta `testWorkSeconds`, sostituita dalla modalità «Secondi e secondi». Vanno aggiornati `docs/sailfish.md`, il design (D6) e le istruzioni di pulizia.

Fuori scope: ore come unità, durate diverse per cicli successivi (pausa lunga del Pomodoro), preset con nome.

## Capabilities

### New Capabilities
<!-- Nessuna. -->

### Modified Capabilities
- `break-cycle`: cambia il requisito «Durate configurabili» (unità e intervalli in base alla modalità, valore predefinito della modalità, comportamento al cambio di modalità). La spec principale esisterà dopo l'archiviazione di `sailfish-mvp`.

## Impact

- `project_sailfish_os/qml/pages/SettingsPage.qml` (menu delle unità, slider che si adattano) ed eventualmente `StepSlider.qml`.
- `qml/harbour-202020.qml`: nuova chiave dconf per la modalità, calcolo delle durate in secondi, rimozione di `testWorkSeconds`.
- `CycleController.qml` non cambia: riceve già le durate in secondi.
- Traduzioni: nuove stringhe in inglese e italiano.
- `docs/sailfish.md`: elenco delle chiavi dconf e procedura di prova senza `testWorkSeconds`.
- Nessuna nuova dipendenza.
