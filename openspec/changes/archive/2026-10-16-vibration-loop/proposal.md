# Proposal

## Why

Con i tipi «Suono» e «Notifica» e la ripetizione «In loop», oggi il telefono vibra solo al primo giro, insieme all'accensione dello schermo e all'app che passa in primo piano; poi si ripete solo il suono (e con «Notifica» anche il banner). Chi tiene il telefono in tasca o in silenzioso perde facilmente l'avviso. Una vibrazione che si ripete insieme al suono lo rende percepibile fino allo «Stop».

## What Changes

- Nuovo interruttore «Vibra a ogni ripetizione» / «Vibrate at every repeat», visibile solo con la ripetizione «In loop» e i tipi «Suono» o «Notifica». Spento per impostazione predefinita, così il comportamento attuale resta quello di chi aggiorna.
- Acceso, la vibrazione si ripete a ogni giro del loop (ogni 4 s), insieme al suono, fino allo «Stop».
- La vibrazione segue la stessa regola della prima vibrazione di oggi, che non dipende dal profilo né da «non disturbare»:
  - col profilo silenzioso, dove il suono è muto, l'avviso diventa una vibrazione ripetuta: un pregio voluto;
  - con «non disturbare» la vibrazione si ripete anche se il suono è muto, come già avviene per la prima.
- Con «Sveglia» l'interruttore non compare: la vibrazione la gestisce l'evento di sistema della sveglia.

Fuori scope: scegliere l'intensità o il ritmo della vibrazione, un loop di sola vibrazione separato dal suono.

## Capabilities

### New Capabilities
<!-- Nessuna. -->

### Modified Capabilities
- `break-alerts`: nuovo requisito «Vibrazione in loop».

## Impact

- `project_sailfish_os/qml/AlertPlayer.qml`: il timer del loop avvia anche la vibrazione quando l'interruttore è acceso.
- `qml/harbour-202020.qml` e `SettingsPage.qml`: nuova chiave dconf `loopVibration` (booleana, predefinita `false`) e interruttore.
- `docs/sailfish.md` (chiave dconf), `docs/acceptance-checklist.md` (nuove righe), traduzioni.
- Nessun nuovo permesso o dipendenza: la vibrazione usa già `HapticsEffect`.
