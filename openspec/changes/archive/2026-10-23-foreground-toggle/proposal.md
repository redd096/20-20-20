# Proposal

## Why

Oggi, alla fine di ogni fase, l'app chiude le impostazioni e si porta in primo piano (`showMainPage()` in `qml/harbour-202020.qml`), così il pulsante «Stop» è subito visibile. Chi sta usando un'altra app viene però interrotto ogni 20 minuti. Deve poter scegliere di ricevere solo l'avviso, restando dov'è.

## What Changes

- Nuovo interruttore nelle impostazioni, sezione «Alert»: «Bring app to front» / «Porta l'app in primo piano». Acceso per impostazione predefinita, cioè il comportamento attuale.
- Acceso: nessun cambiamento (chiude le impostazioni e porta l'app in primo piano).
- Spento: alla fine della fase parte l'avviso e l'app chiude comunque le impostazioni (torna alla pagina principale), ma **non** si porta in primo piano. Quando l'utente apre l'app dalla Home trova subito «Stop».
- Per fermare un avviso in loop con l'interruttore spento, l'utente apre l'app a mano (Home, cover). È una scelta consapevole di chi spegne l'interruttore.
- Checklist: nuova riga per il caso già esistente oggi, cioè le impostazioni chiuse mentre l'utente trascina uno slider. Con durate brevi, trascinare uno slider mentre la fase finisce: l'app non si blocca e resta salvato il valore precedente, perché `StepSlider` salva solo al rilascio.

Fuori scope (idee rimandate):
- toccare la notifica per aprire l'app. Oggi il tocco la chiude soltanto. Servirebbero `remoteActions` e un `DBusAdaptor`, più uno spike su Sailjail e Harbour;
- un'azione «Stop» sulla cover o nella notifica.

## Capabilities

### New Capabilities
<!-- Nessuna. -->

### Modified Capabilities
- `break-alerts`: portare l'app in primo piano a fine fase diventa configurabile; la pagina principale viene mostrata in entrambi i casi.

## Impact

- `project_sailfish_os/qml/harbour-202020.qml`: nuova chiave dconf `bringToFront` (predefinita `true`); `activate()` dentro `showMainPage()` solo se è attiva.
- `qml/pages/SettingsPage.qml`: `TextSwitch` nella sezione «Alert».
- Traduzioni (italiano), `docs/sailfish.md`, `docs/acceptance-checklist.md` (interruttore acceso/spento + riga del trascinamento).
