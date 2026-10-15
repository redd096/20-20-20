# Proposal

## Why

Oggi, alla fine di ogni fase, l'app chiude le impostazioni e si porta in primo piano (`showMainPage()` in `qml/harbour-202020.qml`), così il pulsante «Stop» è subito visibile. Chi sta usando un'altra app viene però interrotto ogni 20 minuti. Deve poter scegliere di ricevere solo l'avviso, restando dov'è.

## What Changes

- Nuovo interruttore nelle impostazioni, sezione «Alert»: «Bring app to front» / «Porta l'app in primo piano». Acceso per impostazione predefinita, cioè il comportamento attuale.
- Spento: alla fine della fase parte solo l'avviso; l'app resta ridotta a icona e non chiude le impostazioni.
- **Da decidere nella design: come si ferma l'avviso in loop senza aprire l'app.** Oggi la notifica non ha azioni. Opzioni:
  - aprire l'app a mano (scomodo, soprattutto con «In loop»);
  - toccare la notifica apre l'app (azione predefinita con `remoteActions`, che richiede un servizio D-Bus dell'app);
  - un'azione «Stop» sulla cover (già tra le idee rimandate);
  - un pulsante «Stop» nella notifica.
- Da verificare con un mini-spike: cosa succede oggi toccando la notifica; se `remoteActions` passa la validazione Harbour e le regole di Sailjail.
- Combinazione da considerare: con questo interruttore spento e «Mostra negli Eventi» spento (change `events-toggle`) resta solo il banner; serve un modo affidabile per fermare l'avviso.

Fuori scope: azioni diverse da «Stop» o «apri l'app».

## Capabilities

### New Capabilities
<!-- Nessuna. -->

### Modified Capabilities
- `break-alerts`: nuovo requisito sul portare l'app in primo piano a fine fase, configurabile, e su come fermare l'avviso dall'esterno dell'app.

## Impact

- `project_sailfish_os/qml/harbour-202020.qml`: condizione attorno a `showMainPage()`, nuova chiave dconf (per esempio `bringToFront`, predefinita `true`).
- `qml/pages/SettingsPage.qml`: `TextSwitch` nella sezione «Alert».
- In base alla scelta per fermare l'avviso: `AlertPlayer.qml` (azioni della notifica), `qml/cover/CoverPage.qml` (azione della cover), eventuale file di servizio D-Bus nel pacchetto.
- Traduzioni, `docs/sailfish.md`, checklist di accettazione.
