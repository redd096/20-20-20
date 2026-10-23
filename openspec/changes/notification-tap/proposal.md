# Proposal

## Why

Oggi toccare la notifica dell'avviso, nel banner o negli Eventi, la chiude soltanto. Chi tiene spento «Porta l'app in primo piano» si aspetta che il tocco apra l'app, sulla pagina principale con «Stop», come fanno le altre app.

## What Changes

- Toccare la notifica (banner o Eventi) porta l'app in primo piano sulla pagina principale, anche con «Porta l'app in primo piano» spento.
- L'app espone un piccolo servizio D-Bus con un solo metodo che mostra la pagina principale; la notifica lo chiama come azione predefinita (`remoteActions`).
- LED delle notifiche: oggi a schermo spento non lampeggia, perché la notifica non ha l'hint `x-nemo-feedback`. Dal QML non si imposta direttamente: si usa la categoria di sistema `im.received`, che lo imposta a `communication_led`, l'evento ngfd che accende solo il LED (`PatternCommunicationIM`), senza suono né vibrazione, quindi valido per tutti e tre i tipi di avviso. Come nelle altre app, il LED si spegne quando l'utente apre la vista Eventi.
- Da verificare sul telefono: se dopo «Stop», senza passare dagli Eventi, il LED continua a lampeggiare. Se sì, decidere allora se «Stop» deve chiudere anche la notifica.
- Nessun file `.service` né `ExecDBus`: quando c'è una notifica l'app è per forza aperta, perché il ciclo vive dentro l'app.

Verifiche già fatte (2026-10-23):
- Sailjail: `OrganizationName` + «.» + `ApplicationName` del `.desktop` è il nome D-Bus che l'app può registrare, pensato anche per le notifiche (documentazione Sailfish, «Launchers»). Per noi `org.redd096.harbour-202020`.
- Fernschreiber (installato sul telefono dal Jolla Store) fa esattamente questo: `remoteAction("default", ...)` verso `de.ygriega.fernschreiber`, il suo `OrganizationName.ApplicationName`. Quindi lo Store accetta un servizio D-Bus proprio usato dalla notifica. Il suo `ApplicationName` è `fernschreiber`: il prefisso `harbour-` è obbligatorio solo per pacchetto, eseguibile, `.desktop` e icona, non per `ApplicationName`.
- Validatore Harbour dell'SDK: `Nemo.DBus 2.0` e `Nemo.Notifications 1.0` ammessi, nessuna regola contro un servizio D-Bus proprio. Il limite del Jolla Store discusso a gennaio 2026 riguarda le chiamate ai servizi D-Bus di altre app, non il proprio.

Da verificare sul telefono durante l'implementazione: che Sailjail accetti il trattino in `harbour-202020` (i nomi D-Bus lo ammettono). Se no, riserva: cambiare `ApplicationName` senza trattino (per esempio `app202020`), verificando che le impostazioni in dconf restino leggibili dalla sandbox; se anche questo non va, la notifica resta com'è oggi.

Fuori scope: pulsanti nella notifica (per esempio «Stop»), avvio dell'app da spenta.

## Capabilities

### New Capabilities
<!-- Nessuna. -->

### Modified Capabilities
- `break-alerts`: il tocco sulla notifica apre l'app sulla pagina principale; la notifica accende il LED a schermo spento.

## Impact

- `project_sailfish_os/qml/harbour-202020.qml` (o `AlertPlayer.qml`): `DBusAdaptor` di `Nemo.DBus` con il metodo che porta l'app in primo piano.
- `project_sailfish_os/qml/AlertPlayer.qml`: `remoteActions` con l'azione `default` e la categoria `im.received` sulla `Notification`.
- `docs/sailfish.md` (nome D-Bus), `docs/acceptance-checklist.md` (tocco su banner ed Eventi, con l'interruttore acceso e spento; LED a schermo spento, spento dopo la vista Eventi, comportamento dopo «Stop»).
