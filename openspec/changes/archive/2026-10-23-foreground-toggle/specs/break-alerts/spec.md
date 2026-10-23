# Spec Delta

## ADDED Requirements

### Requirement: App in primo piano a fine fase

Quando parte l'avviso di fine fase, l'app SHALL tornare alla pagina principale, chiudendo le impostazioni se aperte. L'utente SHALL poter scegliere se l'app si porta anche in primo piano (predefinito: sì). Se no, l'app MUST NOT portarsi in primo piano e l'utente la apre da sé per premere «Stop». La scelta SHALL restare salvata anche dopo la chiusura dell'app.

#### Scenario: In primo piano
- **WHEN** l'interruttore è acceso, l'utente sta usando un'altra app e il lavoro finisce
- **THEN** l'app si porta in primo piano sulla pagina principale, con «Stop» visibile

#### Scenario: Solo avviso
- **WHEN** l'interruttore è spento, l'utente sta usando un'altra app e il lavoro finisce
- **THEN** parte l'avviso, l'utente resta nell'altra app e, aprendo l'app dalla Home, trova la pagina principale con «Stop»

#### Scenario: Impostazioni chiuse durante un trascinamento
- **WHEN** l'utente sta trascinando uno slider delle impostazioni e la fase finisce
- **THEN** le impostazioni si chiudono senza errori e la durata resta quella salvata prima del trascinamento

#### Scenario: Interruttore conservato
- **WHEN** l'utente spegne l'interruttore, chiude l'app e la riapre
- **THEN** l'interruttore è spento
