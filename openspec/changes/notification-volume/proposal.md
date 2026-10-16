# Proposal

## Why

Oggi l'avviso «Notifica» lo riproduce il sistema (lipstick) sul volume Suoneria: chi tiene la suoneria alta per le chiamate sente l'avviso ogni 20 minuti a quel volume, e non può abbassarlo senza abbassare anche le chiamate. Un tipo di avviso sul volume delle applicazioni separa le due cose. Con l'app aperta, i tasti del volume regolano proprio il volume delle applicazioni, quindi l'utente lo imposta in modo naturale.

## What Changes

- Il menu «Tipo» passa da due a tre voci, ognuna con una descrizione che dice quando funziona e che limiti ha:
  - «Suono» (nuovo, predefinito): il suono lo riproduce l'app con `Audio` di QtMultimedia, usando lo stesso file di sistema di oggi, sul volume delle applicazioni.
  - «Notifica»: il comportamento attuale, invariato (volume Suoneria, banner ripetuto a ogni giro del loop).
  - «Sveglia»: invariata.
- Con «Suono»:
  - col profilo silenzioso il suono è muto (resta la vibrazione), come verificato nello spike del 12 ottobre;
  - con «non disturbare» il suono è muto: l'app legge lo stato dalla chiave dconf di sistema `/lipstick/do_not_disturb`. Sulla release 24 il suono di `Audio` si sentiva anche con «non disturbare»;
  - la notifica critica viene pubblicata una sola volta e senza suono (accende lo schermo e lascia la voce negli Eventi), come per la «Sveglia»;
  - col loop si ripete solo il suono, quindi il banner compare una sola volta.
- Il permesso Sailjail `Audio`, tolto nella release 14, torna nel `.desktop`. Minidoro lo usa ed è pubblicato su Harbour. Verificato sulla release 24: `check` di Harbour superato e notifiche presenti negli Eventi (B11).

Fuori scope:
- Uno slider di volume dell'app: sarebbe solo una percentuale del volume delle applicazioni (scartato dall'utente il 14 ottobre 2026).
- La scelta del suono.
- Un banner unico per «Notifica»: lì il suono lo riproduce la notifica stessa, e ripetere solo il suono disegnava un banner vuoto. Servirebbe un suono riprodotto dall'app sul volume Suoneria (per esempio un evento `ngfd`), con un altro spike.

## Capabilities

### New Capabilities
<!-- Nessuna. -->

### Modified Capabilities
- `break-alerts`: cambia il requisito «Tipo di avviso» (tre tipi, «Suono» predefinito; «Suono» e «Notifica» muti col profilo silenzioso e con «non disturbare») e si aggiunge «Banner dell'avviso» (un solo banner con «Suono» e «Sveglia», ripetuto con «Notifica»). «Ripetizione dell'avviso» resta valido così com'è.

## Impact

- `project_sailfish_os/qml/AlertPlayer.qml`: tipo `sound` con `Audio` (notifica senza suono, vibrazione, loop del suono, controllo di «non disturbare»).
- `qml/harbour-202020.qml` e `SettingsPage.qml`: `alertType` con tre valori, predefinito `sound`; menu «Tipo» con tre voci.
- `harbour-202020.desktop`: permesso Sailjail `Audio`.
- `docs/sailfish.md` (chiave dconf), `docs/acceptance-checklist.md` (nuove righe), traduzioni.
- Nessuna nuova dipendenza: QtMultimedia è già ammesso in Harbour.
