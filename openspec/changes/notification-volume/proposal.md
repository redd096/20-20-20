# Proposal

## Why

Oggi l'avviso «Notifica» lo riproduce il sistema (lipstick) sul volume Suoneria: chi tiene la suoneria alta per le chiamate sente l'avviso ogni 20 minuti a quel volume, e non può abbassarlo senza abbassare anche le chiamate. Lasciare scegliere il volume Applicazioni separa le due cose, sempre rispettando il profilo silenzioso.

Da fare dopo l'archiviazione di `sailfish-mvp`, su una base già verificata.

## What Changes

- Nuova impostazione «Volume», visibile solo col tipo «Notifica», con due valori:
  - «Volume applicazioni» (predefinito): il suono lo riproduce l'app con `Audio` di QtMultimedia, sul volume Applicazioni.
  - «Volume suoneria»: il comportamento attuale, suono riprodotto dalla notifica di sistema.
- Con «Volume applicazioni» la notifica critica resta, ma senza suono (accende lo schermo e lascia la voce negli Eventi), come già per la «Sveglia».
- Da verificare con un mini-spike (lo spike del 12 ottobre dice che `Audio` usa il volume Applicazioni ed è muto col silenzioso):
  - comportamento con «non disturbare» e con lo schermo spento e l'app ridotta a icona;
  - il permesso Sailjail `Audio`, tolto nella release 14, va rimesso: controllare che `sfdk check` passi e che le notifiche restino negli Eventi (vedi task 6.8 di `sailfish-mvp`);
  - il loop: ripetere il suono con `Audio` invece di ripubblicare la notifica, e se il banner va comunque ripubblicato.

Fuori scope: uno slider di volume dell'app (sarebbe solo una percentuale del volume Applicazioni, scartato dall'utente il 14 ottobre 2026), scelta del suono.

## Capabilities

### New Capabilities
<!-- Nessuna. -->

### Modified Capabilities
- `break-alerts`: cambia il requisito «Tipo di avviso» (con «Notifica», scelta tra volume Suoneria e volume Applicazioni; entrambi rispettano il profilo silenzioso). La spec principale esisterà dopo l'archiviazione di `sailfish-mvp`.

## Impact

- `project_sailfish_os/qml/AlertPlayer.qml`: percorso `Audio` per la «Notifica» col volume Applicazioni, vibrazione e loop.
- `qml/harbour-202020.qml` e `SettingsPage.qml`: nuova chiave dconf (per esempio `notificationVolume`: `app`|`ringtone`, predefinita `app`) e menu.
- `.desktop`: permesso Sailjail `Audio`.
- Design D5 e D6, `docs/sailfish.md` (chiave dconf), traduzioni.
- Nessuna nuova dipendenza: QtMultimedia è già ammesso in Harbour.
