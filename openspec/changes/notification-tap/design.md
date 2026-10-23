# Design

## Context

- La `Notification` (Nemo.Notifications) vive in `AlertPlayer.qml`; `Nemo.DBus 2.0` è già importato lì per ngfd.
- `showMainPage()` in `harbour-202020.qml` chiude le impostazioni e chiama `activate()` solo se `bringToFront` è acceso (change `foreground-toggle`).
- Il `.desktop` dichiara `OrganizationName=org.redd096` e `ApplicationName=harbour-202020`: Sailjail lascia registrare all'app solo `org.redd096.harbour-202020` sul bus di sessione.

## Goals / Non-Goals

**Goals:**
- Un solo metodo D-Bus, chiamato da lipstick al tocco della notifica.
- LED con un hint, senza codice per pilotare mce.

**Non-Goals:**
- Attivazione D-Bus dell'app spenta (`.service`, `ExecDBus`).
- Pilotare il LED direttamente via mce (`req_led_pattern_activate`), come fa Fernschreiber per un suo caso particolare.

## Decisions

### D1. Nomi D-Bus

- Servizio: `org.redd096.harbour-202020` (l'unico permesso da Sailjail; il trattino è valido nei nomi di servizio).
- Percorso: `/org/redd096/harbour202020`; interfaccia: `org.redd096.harbour202020`. Percorsi e interfacce non ammettono il trattino, e Sailjail controlla solo il nome del servizio.
- Metodo: `showMainPage`, senza argomenti.

Alternativa scartata: cambiare subito `ApplicationName` in un nome senza trattino. Sposta la sandbox dell'app e va verificato con dconf; solo come riserva (vedi Rischi).

### D2. Dove sta l'adaptor

`DBusAdaptor` in `harbour-202020.qml`, accanto a `showMainPage()`, perché serve `pageStack` e `activate()` della finestra. `AlertPlayer` riceve solo i nomi per costruire `remoteActions`, come costanti.

### D3. Il tocco porta sempre in primo piano

`showMainPage()` prende un argomento `front`: la fine fase passa `appSettings.bringToFront`, il tocco passa `true`. Una funzione sola per chiudere le impostazioni, nessuna copia.

### D4. LED

La `Notification` QML non espone gli hint (niente `x-nemo-feedback` diretto, verificato nel `plugins.qmltypes` dell'SDK). Si usa allora la categoria di sistema `im.received`, il cui file (`/usr/share/lipstick/notificationcategories/im.received.conf`) contiene solo `x-nemo-feedback=communication_led`: l'evento ngfd `communication_led` accende solo il LED (`PatternCommunicationIM`, blu), quindi non cambia suono né vibrazione dei tre tipi di avviso. Lo spegnimento allo sblocco del telefono è gestito dal sistema.

Alternative scartate: l'hint `notifier` (richiede la `Notification` in C++); pilotare mce direttamente (il LED non si spegnerebbe da solo allo sblocco).

## Risks / Trade-offs

- [Sailjail rifiuta il nome con il trattino] → il tocco non fa nulla e nel log compare l'errore di registrazione. Riserva: `ApplicationName` senza trattino, verificando prima che le impostazioni in dconf restino leggibili; se no, si rinuncia al tocco e resta solo il LED.
- [Il LED resta acceso dopo «Stop» senza passare dagli Eventi] → da osservare sul telefono; se dà fastidio, nuova decisione (per esempio chiudere la notifica allo «Stop»), fuori da questo change.
- [La notifica ripubblicata in loop con il tipo «Notifica» riaccende il LED a ogni giro] → comportamento atteso, come un nuovo messaggio.
