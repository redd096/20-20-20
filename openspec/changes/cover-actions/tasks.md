# Tasks

## 1. Comando sulla cover

- [ ] 1.1 In `project_sailfish_os/qml/cover/CoverPage.qml` aggiungere una `CoverActionList` con un solo `CoverAction`: icona `image://theme/icon-cover-play` e `cycle.confirm()` in «In attesa del lavoro» e «In attesa della pausa», icona `image://theme/icon-cover-cancel` e `cycle.stop()` durante lavoro e pausa; aggiornare il commento in testa («with no actions»); verificare sul telefono che l'icona cambi a ogni stato

## 2. Documentazione

- [ ] 2.1 In `docs/acceptance-checklist.md` aggiungere righe con esito `-` nella sezione A per i tre scenari di «Comando sulla cover», più una per la pausa in corso fermata dalla cover; verificare che ogni scenario abbia una riga

## 3. Build e prova sul telefono

- [ ] 3.1 Portare `Release:` a 28 in `project_sailfish_os/rpm/harbour-202020.spec`, fare la build e il `check` di Harbour, copiare l'RPM sul telefono e cancellare quello della release 27 (l'utente lo installa); verificare che il `check` passi senza nuovi errori
- [ ] 3.2 Sul telefono eseguire le righe con esito `-` della checklist e segnare gli esiti in `docs/acceptance-checklist.md`; verificare che siano tutte `OK`

## Workflow follow-up

- Archiviare la change con `/opsx:archive cover-actions` dopo la prova sul telefono.
