# Proposal

## Why

Oggi ogni avviso lascia una voce negli Eventi, che resta finché l'utente non la tocca o la toglie a mano. Con un ciclo ogni 20 minuti gli Eventi si riempiono di voci già gestite. Come fanno le app di messaggistica (Fernschreiber chiude le notifiche di una chat letta nell'app), una notifica gestita dentro l'app non deve restare negli Eventi.

Sostituisce l'idea precedente di un interruttore «Mostra negli Eventi» (`isTransient`): avrebbe tolto anche il tocco negli Eventi, probabilmente il LED, e la traccia di un avviso perso.

## What Changes

- Quando l'utente preme «Stop» (pagina principale o cover), l'app chiude la notifica dell'avviso: spariscono la voce negli Eventi e, se acceso, il LED.
- Una notifica non gestita (l'utente era lontano) resta negli Eventi come oggi, e il tocco continua ad aprire l'app.
- Nessun interruttore e nessuno spike: `close()` è già usato all'inizio di ogni avviso.

Fuori scope: chiudere la notifica alla chiusura dell'app; nascondere sempre la notifica dagli Eventi.

## Capabilities

### New Capabilities
<!-- Nessuna. -->

### Modified Capabilities
- `break-alerts`: «Fine dell'avviso» include la chiusura della notifica allo «Stop».

## Impact

- `project_sailfish_os/qml/AlertPlayer.qml`: `notification.close()` in `stop()`; aggiornare il commento di `stop()` e quello della categoria (il LED si spegne allo sblocco, non all'apertura degli Eventi).
- `docs/acceptance-checklist.md`: righe per Stop dall'app, Stop dalla cover e avviso non gestito.
