# Tasks

## 1. Tocco sulla notifica

- [x] 1.1 In `project_sailfish_os/qml/harbour-202020.qml` dare a `showMainPage()` un argomento `front` (la fine fase passa `appSettings.bringToFront`) e aggiungere un `DBusAdaptor` con servizio `org.redd096.harbour-202020`, percorso `/org/redd096/harbour202020`, interfaccia `org.redd096.harbour202020` e metodo `showMainPage` che chiama `showMainPage(true)` (design D1-D3); verificare rileggendo il codice che la fine fase si comporti come prima
- [x] 1.2 In `project_sailfish_os/qml/AlertPlayer.qml` aggiungere alla `Notification` la `remoteActions` con l'azione `default` verso quel servizio e metodo; verificare sul telefono che toccare banner ed Eventi apra l'app sulla pagina principale, anche con «Porta l'app in primo piano» spento. Se il servizio non si registra (errore nel log `journalctl`), fermarsi e riaprire la decisione sulla riserva del design

## 2. LED

- [x] 2.1 In `project_sailfish_os/qml/AlertPlayer.qml` impostare sulla `Notification` la categoria `im.received` (design D4); verificare sul telefono che il LED lampeggi a schermo spento e si spenga aprendo gli Eventi, e annotare se resta acceso dopo «Stop» senza passare dagli Eventi

## 3. Documentazione

- [x] 3.1 In `docs/sailfish.md` aggiungere una breve sezione sul servizio D-Bus (nome, metodo, a cosa serve, nessun avvio automatico); verificare rileggendo la sezione
- [x] 3.2 In `docs/acceptance-checklist.md` aggiungere righe con esito `-` nella sezione B per i quattro scenari (tocco sul banner con l'interruttore spento, tocco negli Eventi, LED a schermo spento, LED spento dopo gli Eventi) più una riga di osservazione per il LED dopo «Stop»; verificare che ogni scenario abbia una riga

## 4. Build e prova sul telefono

- [x] 4.1 Portare `Release:` a 29 in `project_sailfish_os/rpm/harbour-202020.spec`, fare la build e il `check` di Harbour, copiare l'RPM sul telefono e cancellare quello della release 28 (l'utente lo installa); verificare che il `check` passi senza nuovi errori
- [x] 4.2 Sul telefono eseguire le righe con esito `-` della checklist e segnare gli esiti in `docs/acceptance-checklist.md`; verificare che siano tutte `OK` e annotare l'osservazione sul LED dopo «Stop»

## Workflow follow-up

- Archiviare la change con `/opsx:archive notification-tap` dopo la prova sul telefono.
