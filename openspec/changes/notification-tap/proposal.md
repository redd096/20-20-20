# Proposal

## Why

Oggi toccare la notifica dell'avviso, nel banner o negli Eventi, la chiude soltanto. Chi tiene spento «Porta l'app in primo piano» si aspetta che il tocco apra l'app, sulla pagina principale con «Stop», come fanno le altre app.

## What Changes

- Toccare la notifica (banner o Eventi) porta l'app in primo piano sulla pagina principale, anche con «Porta l'app in primo piano» spento.
- L'app espone un piccolo servizio D-Bus con un solo metodo che mostra la pagina principale; la notifica lo chiama come azione predefinita (`remoteActions`).
- Nessun file `.service` né `ExecDBus`: quando c'è una notifica l'app è per forza aperta, perché il ciclo vive dentro l'app.

Verifiche già fatte (2026-10-23):
- Sailjail: `OrganizationName` + «.» + `ApplicationName` del `.desktop` è il nome D-Bus che l'app può registrare, pensato anche per le notifiche (documentazione Sailfish, «Launchers»). Per noi `org.redd096.harbour-202020`.
- Fernschreiber (installato sul telefono) fa esattamente questo: `remoteAction("default", ...)` verso `de.ygriega.fernschreiber`, il suo `OrganizationName.ApplicationName`.
- Validatore Harbour dell'SDK: `Nemo.DBus 2.0` e `Nemo.Notifications 1.0` ammessi, nessuna regola contro un servizio D-Bus proprio. Il limite del Jolla Store discusso a gennaio 2026 riguarda le chiamate ai servizi D-Bus di altre app, non il proprio.

Da verificare sul telefono durante l'implementazione: che Sailjail accetti il trattino in `harbour-202020` (i nomi D-Bus lo ammettono). Se no, la notifica resta com'è oggi e il change si chiude senza modifiche al codice.

Fuori scope: pulsanti nella notifica (per esempio «Stop»), avvio dell'app da spenta.

## Capabilities

### New Capabilities
<!-- Nessuna. -->

### Modified Capabilities
- `break-alerts`: il tocco sulla notifica apre l'app sulla pagina principale.

## Impact

- `project_sailfish_os/qml/harbour-202020.qml` (o `AlertPlayer.qml`): `DBusAdaptor` di `Nemo.DBus` con il metodo che porta l'app in primo piano.
- `project_sailfish_os/qml/AlertPlayer.qml`: `remoteActions` con l'azione `default` sulla `Notification`.
- `docs/sailfish.md` (nome D-Bus), `docs/acceptance-checklist.md` (tocco su banner ed Eventi, con l'interruttore acceso e spento).
