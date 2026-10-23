# Spec Delta

## MODIFIED Requirements

### Requirement: Fine dell'avviso

Ogni avviso in corso SHALL interrompersi quando l'utente preme «Stop». Un avviso MUST NOT continuare dopo che lo stato è cambiato. Allo «Stop», dalla pagina principale o dalla cover, l'app SHALL chiudere anche la notifica dell'avviso, che sparisce dagli Eventi; finché l'utente non preme «Stop», la notifica SHALL restare negli Eventi.

#### Scenario: Stop durante il loop
- **WHEN** l'avviso è in loop in «Pausa» scaduta e l'utente preme «Stop»
- **THEN** il suono si interrompe subito e lo stato diventa «In attesa del lavoro»

#### Scenario: Notifica chiusa allo Stop
- **WHEN** il lavoro è scaduto e l'utente preme «Stop», nell'app o sulla cover
- **THEN** la notifica dell'avviso non è più negli Eventi

#### Scenario: Avviso non gestito
- **WHEN** il lavoro è scaduto e l'utente non ha ancora premuto «Stop»
- **THEN** la notifica dell'avviso è negli Eventi e toccarla apre l'app
