# Design

## Context

- `CycleController.qml` gestisce le fasi; `stop()` chiude lavoro e pausa, `confirm()` avvia lavoro o pausa, `restartWork()` riavvia il lavoro. Le durate sono proprietà lette all'avvio di ogni fase.
- `harbour-202020.qml` tiene le impostazioni in un `ConfigurationGroup` (dconf) e le passa al ciclo, con `clampDuration()` per gli intervalli.
- `SettingsPage.qml`: i cursori sono `StepSlider`, letti una volta sola; `setUnits()` riporta le durate ai predefiniti e ricrea i cursori del `Loader` `durationSliders`.
- La cover chiama `confirm()` e `stop()`, quindi riceve la pausa lunga senza modifiche.

## Goals / Non-Goals

**Goals:**
- Tutta la logica Pomodoro nel ciclo; pagine e cover la mostrano soltanto.

**Non-Goals:**
- Contatore salvato, statistiche, testi diversi dell'avviso, contatore sulla cover.

## Decisions

### D1. Contatore nel ciclo

Nuove proprietà di `CycleController`: `worksDone` (0 all'avvio), `longBreakAfter`, `longBreakSeconds`, `pomodoro` (le ultime tre dalle impostazioni) e `longBreak` (vero durante una pausa lunga, in corso o scaduta).

- `stop()` da «working» o «workDone»: `worksDone++`. È l'unico punto da cui un lavoro finisce, sia da pagina sia da cover.
- `confirm()` da «waitBreak»: se `pomodoro` e `worksDone >= longBreakAfter`, avvia la pausa con `longBreakSeconds`, mette `longBreak` a vero e azzera `worksDone`; altrimenti pausa normale con `longBreak` falso.
- `resetCounter()` azzera `worksDone`.

Il contatore conta anche con la modalità spenta (non è visibile): niente casi speciali all'accensione. Chi la accende a metà sessione può usare «Azzera contatore». Il confronto `>=` gestisce anche N abbassato sotto il contatore attuale.

### D2. Impostazioni

Chiavi dconf: `pomodoro` (bool, `false`), `longBreakAfter` (int, 3, limitato a 1-10), `longBreakSeconds` (int, 60, limitato con `clampDuration()` nell'unità della pausa). Il predefinito 60 corrisponde alle unità predefinite (pausa in secondi).

`setUnits()` riceve anche la pausa lunga predefinita: 900 per «Minuti e minuti», 60 per le altre. Il cursore della pausa lunga sta nello stesso `Loader` delle durate, così viene ricreato insieme agli altri.

Sezione «Pomodoro» in fondo, dopo «Alert»: `TextSwitch` come gli altri interruttori (`automaticCheck` spento), due `StepSlider` visibili solo con l'interruttore acceso. Il cursore della pausa lunga sta nel `Loader` ma la sua visibilità segue l'interruttore.

### D3. Pagina principale

- `stateText()` restituisce «Long break» per «onBreak» e «breakDone» quando `cycle.longBreak` è vero.
- Il contatore («2/3») è una `Label` ancorata al fondo della pagina, fuori dalla colonna, visibile solo con la modalità accesa.
- `PullDownMenu`: «Reset counter» sopra «Settings», visibile solo con la modalità accesa.

## Risks / Trade-offs

- [Il cursore della pausa lunga nel `Loader` delle durate si trova lontano dalla sezione «Pomodoro»] → se il `Loader` non si può spezzare, un secondo `Loader` per la sezione Pomodoro, ricreato anch'esso da `setUnits()`; scelta da fare leggendo il codice durante l'implementazione, senza effetti sulla spec.
- [Contatore che conta anche a modalità spenta] → accettato: invisibile, e azzerabile.
