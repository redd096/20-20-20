# Proposal

## Why

La regola 20-20-20 (ogni 20 minuti davanti allo schermo, 20 secondi a guardare un oggetto a circa 6 metri) funziona solo se qualcosa ce la ricorda: serve un'app minimale che scandisca le due fasi e chieda una conferma a ogni passaggio. Partiamo da Sailfish OS perché è il telefono di uso quotidiano, la toolchain (`sfdk`) è già pronta e lì sta il rischio tecnico più grande (suonare a schermo spento usando solo API ammesse nel Jolla Store).

## What Changes

- Nuovo repository git alla radice `app_20_20_20/`, con `openspec/` versionato, `.claude/` e gli output di build esclusi, licenza FOSS e cartelle `project_sailfish_os/` e `docs/` (`project_android/` arriverà con un change successivo).
- Specifica, indipendente dalla piattaforma, del ciclo lavoro/pausa: stati, conferme manuali, durate configurabili e Stop. Sarà la base comune anche per l'app Android.
- Specifica degli avvisi: ripetizione (una volta oppure in loop fino alla conferma) e tipo di suono (sveglia, che suona anche col profilo silenzioso, oppure notifica, che rispetta il profilo).
- App Sailfish OS `harbour-202020` (nome visualizzato «20-20-20»): una pagina con un pulsante principale, il tempo rimanente e una pagina impostazioni. Funziona finché è aperta o ridotta a icona, senza daemon e senza avvio automatico.
- Spike iniziale sul telefono: tenere sveglio il timer a schermo spento e suonare come sveglia col profilo silenzioso usando solo API ammesse in Harbour.

Fuori scope: app Android, comandi da notifica o dalla cover, statistiche, snooze, avvio al boot, widget.

## Capabilities

### New Capabilities
- `break-cycle`: ciclo lavoro/pausa della regola 20-20-20: stati, transizioni con conferma manuale, durate configurabili, Stop e tempo rimanente.
- `break-alerts`: avviso alla fine di ogni fase, con ripetizione e tipo di suono configurabili e funzionamento a schermo spento finché l'app è aperta.

### Modified Capabilities
<!-- Nessuna: il progetto non ha ancora spec. -->

## Impact

- Nuovo codice in `project_sailfish_os/` (QML Silica + launcher C++ `sailfishapp`, packaging RPM `.spec`), costruito con `~/SailfishOS/bin/sfdk` sul target aarch64 già usato per `keyboard_jolla`.
- Dipendenze runtime solo di sistema, da confermare con lo spike: `Sailfish.Silica`, `Nemo.KeepAlive`, `Nemo.Notifications`, `QtMultimedia`, `Nemo.Configuration`.
- Pubblicazione: OpenRepos sempre; Jolla Store solo se lo spike conferma che le API usate sono ammesse in Harbour.
- Nessuna installazione aggiuntiva sul PC.
