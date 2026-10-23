# Tasks

## 1. Interruttore

- [ ] 1.1 In `project_sailfish_os/qml/harbour-202020.qml` aggiungere la chiave `bringToFront` (booleana, predefinita `true`) e in `showMainPage()` chiamare `activate()` solo se è vera, lasciando sempre il `pop` delle impostazioni; aggiornare il commento della funzione; verificare rileggendo la funzione
- [ ] 1.2 In `project_sailfish_os/qml/pages/SettingsPage.qml` aggiungere nella sezione «Alert» un `TextSwitch` «Bring app to front», con `automaticCheck` spento e il clic che inverte il valore salvato, come «Vibrate at every repeat»; verificare sul telefono che il valore resti dopo la riapertura dell'app

## 2. Traduzioni e documentazione

- [ ] 2.1 Dopo la build, tradurre in italiano le nuove stringhe in `project_sailfish_os/translations/harbour-202020-it.ts` («Porta l'app in primo piano»); verificare che il file non contenga voci `type="unfinished"`
- [ ] 2.2 In `docs/sailfish.md` aggiungere `bringToFront` alla tabella delle chiavi; verificare rileggendo la tabella
- [ ] 2.3 In `docs/acceptance-checklist.md` aggiungere righe con esito `-` per i quattro scenari di «App in primo piano a fine fase» (incluso il trascinamento di uno slider mentre la fase finisce, con durate brevi); verificare che ogni scenario abbia una riga

## 3. Build e prova sul telefono

- [ ] 3.1 Portare `Release:` a 27 in `project_sailfish_os/rpm/harbour-202020.spec`, fare la build e il `check` di Harbour, copiare l'RPM sul telefono e cancellare quello della release 26 (l'utente lo installa); verificare che il `check` passi senza nuovi errori
- [ ] 3.2 Sul telefono eseguire le righe con esito `-` della checklist, in italiano, e segnare gli esiti in `docs/acceptance-checklist.md`; verificare che siano tutte `OK`

## Workflow follow-up

- Archiviare la change con `/opsx:archive foreground-toggle` dopo la prova sul telefono.
