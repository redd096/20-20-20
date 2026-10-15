# Proposal

## Why

Oggi ogni avviso lascia una voce negli Eventi (la notifica è `Critical`). Con un ciclo ogni 20 minuti gli Eventi si riempiono di voci che non servono più dopo la pausa, e vanno cancellate a mano. Chi lo trova fastidioso deve poter vedere solo il banner in alto.

Da fare dopo `notification-volume`, il cui spike tocca già il comportamento delle notifiche negli Eventi.

## What Changes

- Nuovo interruttore nelle impostazioni, sezione «Alert»: «Show in Events» / «Mostra negli Eventi». Acceso per impostazione predefinita, cioè il comportamento attuale.
- Spento: la notifica mostra solo il banner in alto e non resta negli Eventi. Candidata la proprietà `isTransient` di `Nemo.Notifications`.
- Vale per tutti i tipi di avviso (anche la notifica muta pubblicata con la «Sveglia»).
- Da verificare con un mini-spike:
  - con `urgency: Critical` e `isTransient: true` lo schermo si accende ancora?
  - con il tipo «Notifica» il suono viene ancora riprodotto?
  - nel loop, ogni ripubblicazione mostra di nuovo il banner?
  - se `isTransient` non basta, alternativa: chiudere la notifica (`close()`) quando l'utente preme «Stop».

Fuori scope: scegliere cosa mostrare nel testo della notifica, raggruppare le voci negli Eventi.

## Capabilities

### New Capabilities
<!-- Nessuna. -->

### Modified Capabilities
- `break-alerts`: nuovo requisito sulla presenza dell'avviso negli Eventi, configurabile.

## Impact

- `project_sailfish_os/qml/AlertPlayer.qml`: proprietà per la notifica transitoria.
- `qml/harbour-202020.qml`: nuova chiave dconf (per esempio `showInEvents`, predefinita `true`).
- `qml/pages/SettingsPage.qml`: `TextSwitch` nella sezione «Alert».
- Traduzioni, `docs/sailfish.md` (chiave dconf), checklist di accettazione.
- Nessuna nuova dipendenza.
