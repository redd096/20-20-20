# Spec Delta

## ADDED Requirements

### Requirement: Comando sulla cover

Con l'app ridotta a icona, la cover SHALL offrire un solo comando, che dipende dallo stato e agisce come il pulsante corrispondente della pagina principale:

- «In attesa del lavoro»: avvia il lavoro.
- «In attesa della pausa»: avvia la pausa.
- «Lavoro» e «Pausa», in corso o scaduti: «Stop», che ferma anche l'avviso.

«Riavvia lavoro» MUST NOT essere offerto sulla cover.

#### Scenario: Avvio del lavoro dalla cover
- **WHEN** lo stato è «In attesa del lavoro» e l'utente tocca il comando della cover
- **THEN** inizia il lavoro e la cover mostra il tempo rimanente

#### Scenario: Avvio della pausa dalla cover
- **WHEN** lo stato è «In attesa della pausa» e l'utente tocca il comando della cover
- **THEN** inizia la pausa e la cover mostra il tempo rimanente

#### Scenario: Stop dalla cover durante l'avviso
- **WHEN** il lavoro è scaduto, l'avviso suona in loop e l'utente tocca il comando della cover
- **THEN** l'avviso si ferma, lo stato diventa «In attesa della pausa» e l'app resta ridotta a icona
