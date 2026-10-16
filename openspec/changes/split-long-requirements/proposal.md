# Proposal

## Why

`openspec validate --strict` segnala tre requisiti con una descrizione oltre i 500 caratteri: ognuno descrive più comportamenti insieme. Dividerli lascia un comportamento per requisito, rende ogni scenario più facile da collegare alla sua regola e fa passare la validazione stretta.

## What Changes

Nessun comportamento dell'app cambia: si riorganizza solo il testo delle spec.

- `break-cycle`, «Stati del ciclo»: restano gli stati e lo stato all'avvio; i comandi mostrati in ogni stato passano al nuovo requisito «Comandi per stato».
- `break-cycle`, «Durate configurabili»: restano la scelta della modalità delle unità, il salvataggio e la regola sulle modifiche durante una fase; gli intervalli passano a «Intervalli delle durate», i predefiniti e il ritorno ai predefiniti al cambio di modalità a «Predefiniti per modalità».
- `break-alerts`, «Tipo di avviso»: restano i tre tipi, i loro volumi e il salvataggio; il comportamento col profilo silenzioso e con «non disturbare» passa a «Profilo silenzioso e non disturbare».

I requisiti originali tengono nome e scenari; ogni requisito nuovo ha scenari propri.

In più il pulsante «Riprendi lavoro» prende nelle spec il nome che ha nell'app dalla release 22, «Riavvia lavoro» (il conto alla rovescia riparte da capo): in «Comandi per stato» e in «Fase di lavoro», requisito e scenario «Lavoro rimandato».

## Capabilities

### New Capabilities
<!-- Nessuna. -->

### Modified Capabilities
- `break-cycle`: «Stati del ciclo» e «Durate configurabili» si accorciano; «Fase di lavoro» usa il nome «Riavvia lavoro»; nuovi «Comandi per stato», «Intervalli delle durate», «Predefiniti per modalità».
- `break-alerts`: «Tipo di avviso» si accorcia; nuovo «Profilo silenzioso e non disturbare».

## Impact

- Solo `openspec/specs/break-cycle/spec.md` e `openspec/specs/break-alerts/spec.md`, all'archiviazione.
- Nessun codice, documento o traduzione: la checklist sul telefono copre già tutti i comportamenti.
