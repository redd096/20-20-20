# Proposal

## Why

La cover mostra già il tempo rimanente e lo stato, ma non ha azioni: per avviare una fase o fermare un avviso bisogna aprire l'app. Con «Porta l'app in primo piano» spento, l'utente deve poter fermare l'avviso dalla Home con un tocco.

## What Changes

- La cover ha un solo pulsante, che cambia con lo stato:
  - «In attesa del lavoro»: avvia il lavoro (icona play);
  - «In attesa della pausa»: avvia la pausa (icona play);
  - «Lavoro» o «Pausa», in corso o scaduti: «Stop» (icona cancel), che ferma anche l'avviso come il pulsante della pagina principale.
- «Riavvia lavoro» resta solo nella pagina principale.
- Le azioni usano le stesse funzioni dei pulsanti della pagina principale, quindi nessuna logica nuova del ciclo.

Fuori scope: altre azioni sulla cover, cambi all'aspetto della cover.

## Capabilities

### New Capabilities
<!-- Nessuna. -->

### Modified Capabilities
- `break-cycle`: comandi disponibili anche dalla cover, per stato.

## Impact

- `project_sailfish_os/qml/cover/CoverPage.qml`: `CoverActionList` con un'azione per stato; commento in testa da aggiornare («Passive cover ... with no actions»).
- `docs/acceptance-checklist.md`: righe per ogni stato.
