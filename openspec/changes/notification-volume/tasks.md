# Tasks

## 1. Tipo «Suono»

- [x] 1.1 In `project_sailfish_os/qml/harbour-202020.qml` togliere `notificationVolume`, portare il predefinito di `alertType` a `sound` e passare ad `AlertPlayer` `alarm` e `notification` così come sono e ogni altro valore come `sound` (design D1); verificare con `grep -rn notificationVolume project_sailfish_os` senza risultati
- [ ] 1.2 In `project_sailfish_os/qml/pages/SettingsPage.qml` togliere il menu «Volume» e dare al menu «Type» tre voci, «Sound», «Notification», «Alarm», ognuna con una descrizione che dice come suona e che limiti ha (per «Notification»: il banner ricompare a ogni ripetizione); lo slider «Alarm length» resta visibile solo con «Alarm» e «Once»; verificare sul telefono le tre descrizioni e lo slider

## 2. Suono col volume delle applicazioni

- [ ] 2.1 In `project_sailfish_os/qml/AlertPlayer.qml` sostituire la proprietà `volume` con il tipo `sound`: notifica pubblicata una volta con `sound` vuoto, vibrazione, `Audio` riprodotto all'inizio e da `notificationLoop`; `stop()` ferma anche `Audio`; aggiornare il commento in testa al file (design D2, D3); verificare sul telefono che in loop il banner compaia una sola volta
- [ ] 2.2 In `AlertPlayer.qml` leggere `/lipstick/do_not_disturb` con un `ConfigurationValue` (predefinito `false`) e saltare ogni riproduzione di `Audio` mentre vale `true` (design D5); verificare sul telefono che con «non disturbare» il tipo «Sound» non emetta suono
- [x] 2.3 Aggiungere `Permissions=Audio` nella sezione `[X-Sailjail]` di `project_sailfish_os/harbour-202020.desktop` (design D4); verificare che il `check` di Harbour passi senza nuovi errori

## 3. Traduzioni e documentazione

- [x] 3.1 Dopo la build, tradurre in italiano le nuove stringhe in `project_sailfish_os/translations/harbour-202020-it.ts` («Suono» e le descrizioni dei tre tipi) e controllare che le stringhe del menu «Volume» non ci siano più; verificare che il file non contenga voci `type="unfinished"`
- [x] 3.2 In `docs/sailfish.md` aggiornare la riga di `alertType` con i tre valori e il predefinito `sound`, e togliere `notificationVolume`; verificare con `grep -n notificationVolume docs/sailfish.md` senza risultati
- [x] 3.3 In `docs/acceptance-checklist.md` adattare le righe B12-B20 e la riga dei valori predefiniti ai tre tipi (aggiungendo una riga per il banner ripetuto con «Notification»), e rimettere a `-` le righe da ripetere; verificare che ogni scenario di «Tipo di avviso» e «Banner dell'avviso» abbia una riga

## 4. Build e prova sul telefono

- [ ] 4.1 Portare `Release:` a 25 in `project_sailfish_os/rpm/harbour-202020.spec`, fare la build e il `check` di Harbour, copiare l'RPM sul telefono e cancellare quello della release 24 (l'utente lo installa e lancia `dconf reset -f /apps/harbour-202020/`); verificare che il `check` passi senza nuovi errori
- [ ] 4.2 Sul telefono eseguire le righe con esito `-` della checklist, in italiano, e segnare gli esiti in `docs/acceptance-checklist.md`; se con «non disturbare» il tipo «Sound» suona ancora, fermarsi (design, Risks); verificare che siano tutte `OK`

## Workflow follow-up

- Archiviare la change con `/opsx:archive notification-volume` dopo la prova sul telefono.
