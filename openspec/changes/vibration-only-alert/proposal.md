# Proposal

## Why

Oggi l'avviso ha sempre un suono: «Notifica» sul volume Suoneria, «Sveglia» sul volume Sveglia. Chi lavora in un ambiente silenzioso (ufficio, biblioteca), o tiene il telefono in tasca o sulla scrivania, può volere solo la vibrazione, senza mettere il telefono in silenzioso.

Da fare dopo `notification-volume`, che modifica lo stesso requisito «Tipo di avviso» e lo stesso `AlertPlayer.qml`.

## What Changes

- Terzo valore nel menu «Tipo»: «Vibration only» / «Solo vibrazione».
- Con «Solo vibrazione» l'app vibra con `HapticsEffect` (già usato oggi per la «Notifica») e pubblica una notifica senza suono, come già fa la «Sveglia», per accendere lo schermo e mostrare il messaggio.
- La ripetizione funziona come per gli altri tipi: «Una volta» vibra una volta sola, «In loop» ripete la vibrazione finché l'utente non preme «Stop».
- Da verificare con un mini-spike:
  - `HapticsEffect` rispetta l'impostazione di sistema che disattiva la vibrazione? Se no, va deciso se rispettarla a mano o ignorarla (è l'unico segnale dell'avviso).
  - La vibrazione funziona a schermo spento e con l'app ridotta a icona (il loop ha già `KeepAlive`)?
  - Comportamento con «non disturbare»: la vibrazione parte comunque? La notifica senza suono accende ancora lo schermo?
  - Durata e pausa del loop: una vibrazione da 800 ms ogni quanti secondi è riconoscibile senza essere fastidiosa?

Fuori scope: schemi di vibrazione personalizzati, intensità regolabile.

## Capabilities

### New Capabilities
<!-- Nessuna. -->

### Modified Capabilities
- `break-alerts`: cambia il requisito «Tipo di avviso» (terzo tipo «Solo vibrazione») e il requisito sull'avviso sonoro, che oggi chiede sempre un suono.

## Impact

- `project_sailfish_os/qml/AlertPlayer.qml`: nuovo tipo `vibration`, loop della vibrazione.
- `qml/harbour-202020.qml`: `alertType` accetta `"vibration"`.
- `qml/pages/SettingsPage.qml`: nuova voce nel menu «Tipo» e relativa descrizione.
- Traduzioni, `docs/sailfish.md` (valori di `alertType`), checklist di accettazione.
- Nessuna nuova dipendenza.
