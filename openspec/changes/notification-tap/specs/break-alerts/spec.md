# Spec Delta

## ADDED Requirements

### Requirement: Tocco sulla notifica

Toccare la notifica dell'avviso, nel banner o nella vista Eventi, SHALL portare l'app in primo piano sulla pagina principale, chiudendo le impostazioni se aperte. Questo SHALL valere anche con «Porta l'app in primo piano» spento, perché il tocco è una richiesta esplicita dell'utente.

#### Scenario: Tocco sul banner con l'interruttore spento
- **WHEN** «Porta l'app in primo piano» è spento, l'utente usa un'altra app, il lavoro finisce e l'utente tocca il banner
- **THEN** l'app si porta in primo piano sulla pagina principale, con «Stop»

#### Scenario: Tocco nella vista Eventi
- **WHEN** l'avviso è partito con l'app ridotta a icona e l'utente tocca la notifica nella vista Eventi
- **THEN** l'app si porta in primo piano sulla pagina principale

### Requirement: LED delle notifiche

La notifica dell'avviso SHALL far lampeggiare il LED delle notifiche del dispositivo a schermo spento, con qualsiasi tipo di avviso, senza aggiungere suoni o vibrazioni. Come per le altre notifiche, il LED SHALL spegnersi quando l'utente sblocca il telefono.

#### Scenario: LED a schermo spento
- **WHEN** il lavoro finisce con lo schermo spento e lo schermo si spegne di nuovo senza che l'utente sblocchi il telefono
- **THEN** il LED delle notifiche lampeggia

#### Scenario: LED spento allo sblocco
- **WHEN** il LED lampeggia e l'utente sblocca il telefono
- **THEN** il LED smette di lampeggiare
