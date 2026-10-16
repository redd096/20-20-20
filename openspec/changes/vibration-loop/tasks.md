# Tasks

## 1. Interruttore e vibrazione in loop

- [ ] 1.1 In `project_sailfish_os/qml/harbour-202020.qml` aggiungere la chiave `loopVibration` (booleana, predefinita `false`) e passarla ad `AlertPlayer` come proprietà `vibrateInLoop`; verificare leggendo il binding
- [ ] 1.2 In `project_sailfish_os/qml/AlertPlayer.qml` far avviare `vibra` anche da `notificationLoop` quando `vibrateInLoop` è vero, senza controlli di profilo o «non disturbare», come per la prima vibrazione; verificare sul telefono che con l'interruttore acceso il telefono vibri a ogni giro e smetta allo «Stop»
- [ ] 1.3 In `project_sailfish_os/qml/pages/SettingsPage.qml` aggiungere un `TextSwitch` «Vibrate at every repeat», visibile solo con «Loop until stopped» e il tipo «Sound» o «Notification», letto in `Component.onCompleted` e salvato al clic come gli altri controlli; verificare sul telefono che sparisca con «Once» e con «Alarm»

## 2. Traduzioni e documentazione

- [ ] 2.1 Dopo la build, tradurre in italiano le nuove stringhe in `project_sailfish_os/translations/harbour-202020-it.ts`; verificare che il file non contenga voci `type="unfinished"`
- [ ] 2.2 In `docs/sailfish.md` aggiungere `loopVibration` alla tabella delle chiavi; verificare rileggendo la tabella
- [ ] 2.3 In `docs/acceptance-checklist.md` aggiungere righe con esito `-` per i quattro scenari di «Vibrazione in loop» e per la visibilità dell'interruttore; verificare che ogni scenario abbia una riga

## 3. Build e prova sul telefono

- [ ] 3.1 Portare `Release:` a 26 in `project_sailfish_os/rpm/harbour-202020.spec`, fare la build e il `check` di Harbour, copiare l'RPM sul telefono e cancellare quello della release 25 (l'utente lo installa); verificare che il `check` passi senza nuovi errori
- [ ] 3.2 Sul telefono eseguire le righe con esito `-` della checklist, in italiano, e segnare gli esiti in `docs/acceptance-checklist.md`; verificare che siano tutte `OK`

## Workflow follow-up

- Archiviare la change con `/opsx:archive vibration-loop` dopo la prova sul telefono.
