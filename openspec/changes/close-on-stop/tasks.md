# Tasks

## 1. Chiusura allo Stop

- [x] 1.1 In `project_sailfish_os/qml/AlertPlayer.qml` chiamare `notification.close()` in `stop()` e aggiornare il suo commento; correggere il commento della categoria (il LED si spegne allo sblocco); verificare rileggendo che `start()`, che chiama `stop()`, pubblichi comunque la nuova notifica

## 2. Documentazione

- [x] 2.1 In `docs/acceptance-checklist.md` aggiungere righe con esito `-` nella sezione B per Stop dall'app, Stop dalla cover e avviso non gestito; verificare che ogni scenario abbia una riga

## 3. Build e prova sul telefono

- [x] 3.1 Portare `Release:` a 30 in `project_sailfish_os/rpm/harbour-202020.spec`, fare la build e il `check` di Harbour, copiare l'RPM sul telefono e cancellare quello della release 29 (l'utente lo installa); verificare che il `check` passi senza nuovi errori
- [ ] 3.2 Sul telefono eseguire le righe con esito `-` della checklist e segnare gli esiti in `docs/acceptance-checklist.md`; verificare che siano tutte `OK`

## Workflow follow-up

- Archiviare la change con `/opsx:archive close-on-stop` dopo la prova sul telefono.
