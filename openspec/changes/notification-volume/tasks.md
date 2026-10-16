# Tasks

## 1. Impostazione «Volume»

- [x] 1.1 In `project_sailfish_os/qml/harbour-202020.qml` aggiungere la chiave `notificationVolume` (`app` | `ringtone`, predefinita `app`) e passarla ad `AlertPlayer` come proprietà `volume`, con ogni valore diverso da `ringtone` letto come `app` (design D1); verificare leggendo il binding
- [ ] 1.2 In `project_sailfish_os/qml/pages/SettingsPage.qml` aggiungere sotto «Type» il `ComboBox` «Volume» con «Application volume» e «Ringtone volume», visibile solo col tipo «Notification», letto in `Component.onCompleted` e salvato in `MenuItem.onClicked` come gli altri menu; la descrizione di «Application volume» dice che segue il volume delle app, è muto in modalità silenziosa e suona anche con «non disturbare»; quella di «Ringtone volume» riprende il testo attuale della «Notification»; verificare sul telefono che il menu sparisca col tipo «Alarm»

## 2. Suono col volume Applicazioni

- [ ] 2.1 In `project_sailfish_os/qml/AlertPlayer.qml` aggiungere l'elemento `Audio` con `notificationSoundFile` e il percorso `volume: app`: notifica pubblicata una volta con `sound` vuoto, vibrazione, `Audio.play()`, e `notificationLoop` che col volume `app` richiama `Audio.play()` invece di ripubblicare la notifica; `stop()` ferma anche `Audio`; aggiornare il commento in testa al file (design D2, D3); verificare sul telefono che in loop il banner compaia una sola volta
- [x] 2.2 Aggiungere `Permissions=Audio` nella sezione `[X-Sailjail]` di `project_sailfish_os/harbour-202020.desktop` (design D4); verificare che il `check` di Harbour passi senza nuovi errori

## 3. Traduzioni e documentazione

- [x] 3.1 Dopo la prima build, tradurre in italiano le nuove stringhe in `project_sailfish_os/translations/harbour-202020-it.ts` («Volume», «Volume applicazioni», «Volume suoneria» e le due descrizioni); verificare che il file non contenga voci `type="unfinished"`
- [ ] 3.2 In `docs/sailfish.md` aggiungere `notificationVolume` alla tabella delle chiavi e correggere la descrizione di `alertType` (`notification` non segue più sempre il volume Suoneria); verificare rileggendo la tabella
- [ ] 3.3 In `docs/acceptance-checklist.md` aggiungere righe con esito `-` per gli scenari di «Volume della notifica» (predefinito, volume Applicazioni coi tasti, silenzioso, «non disturbare» con i due volumi, un solo banner in loop, volume conservato) e per «Una volta» a schermo spento col volume Applicazioni (il suono si sente intero, vedi design Risks), e rimettere a `-` A14 (nuovo predefinito), B3, B4, B5, B10 e B11; verificare che ogni nuovo scenario della spec abbia una riga

## 4. Build e prova sul telefono

- [ ] 4.1 Portare `Release:` a 24 in `project_sailfish_os/rpm/harbour-202020.spec`, fare la build e il `check` di Harbour, copiare l'RPM sul telefono e cancellare quello della release 23 (l'utente lo installa); verificare che il `check` passi senza nuovi errori
- [ ] 4.2 Sul telefono eseguire le righe con esito `-` della checklist, in italiano, e segnare gli esiti in `docs/acceptance-checklist.md`; se B11 fallisce, fermarsi e riaprire la decisione sul permesso (design, Risks); verificare che siano tutte `OK`

## Workflow follow-up

- Archiviare la change con `/opsx:archive notification-volume` dopo la prova sul telefono.
