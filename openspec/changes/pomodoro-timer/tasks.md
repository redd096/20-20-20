# Tasks

## 1. Ciclo

- [ ] 1.1 In `project_sailfish_os/qml/CycleController.qml` aggiungere `worksDone`, `pomodoro`, `longBreakAfter`, `longBreakSeconds`, `longBreak` e `resetCounter()`; contare in `stop()` la fine del lavoro; in `confirm()` da «waitBreak» scegliere pausa lunga o normale e azzerare il contatore alla pausa lunga (design D1); aggiornare il commento in testa; verificare rileggendo le transizioni contro gli scenari di `pomodoro`
- [ ] 1.2 In `project_sailfish_os/qml/harbour-202020.qml` aggiungere le chiavi `pomodoro`, `longBreakAfter`, `longBreakSeconds` e passarle al ciclo con i limiti (design D2); verificare rileggendo i binding

## 2. Impostazioni

- [ ] 2.1 In `project_sailfish_os/qml/pages/SettingsPage.qml` estendere `setUnits()` con la pausa lunga predefinita e aggiungere la sezione «Pomodoro» (interruttore e due cursori, design D2); verificare sul telefono che i cursori compaiano solo con l'interruttore acceso e che il cambio di modalità riporti la pausa lunga al predefinito

## 3. Pagina principale

- [ ] 3.1 In `project_sailfish_os/qml/pages/MainPage.qml` mostrare «Long break», il contatore in basso e la voce «Reset counter» (design D3); verificare sul telefono che contatore e voce compaiano solo con la modalità accesa

## 4. Traduzioni e documentazione

- [ ] 4.1 Dopo la build, tradurre in italiano le nuove stringhe in `project_sailfish_os/translations/harbour-202020-it.ts`; verificare che il file non contenga voci `type="unfinished"`
- [ ] 4.2 In `docs/sailfish.md` aggiungere le tre chiavi alla tabella; verificare rileggendo la tabella
- [ ] 4.3 In `docs/acceptance-checklist.md` aggiungere una sezione per `pomodoro` con righe `-` per ogni scenario di `pomodoro` e per «Pausa lunga al cambio di modalità»; verificare che ogni scenario abbia una riga

## 5. Build e prova sul telefono

- [ ] 5.1 Portare `Release:` a 31 in `project_sailfish_os/rpm/harbour-202020.spec`, fare la build e il `check` di Harbour, copiare l'RPM sul telefono e cancellare quello della release 30 (l'utente lo installa); verificare che il `check` passi senza nuovi errori
- [ ] 5.2 Sul telefono eseguire le righe con esito `-` della checklist, in italiano, e segnare gli esiti in `docs/acceptance-checklist.md`; verificare che siano tutte `OK`

## Workflow follow-up

- Archiviare la change con `/opsx:archive pomodoro-timer` dopo la prova sul telefono.
