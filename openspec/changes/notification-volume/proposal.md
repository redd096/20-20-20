# Proposal

## Why

Oggi l'avviso «Notifica» lo riproduce il sistema (lipstick) sul volume Suoneria: chi tiene la suoneria alta per le chiamate sente l'avviso ogni 20 minuti a quel volume, e non può abbassarlo senza abbassare anche le chiamate. Lasciare scegliere il volume Applicazioni separa le due cose. Con l'app aperta, i tasti del volume regolano proprio il volume Applicazioni, quindi l'utente lo imposta in modo naturale.

## What Changes

- Nuova impostazione «Volume», visibile solo col tipo «Notifica», con due valori:
  - «Volume applicazioni» (predefinito): il suono lo riproduce l'app con `Audio` di QtMultimedia, usando lo stesso file di sistema di oggi, sul volume Applicazioni.
  - «Volume suoneria»: il comportamento attuale, invariato.
- Con «Volume applicazioni»:
  - col profilo silenzioso il suono è muto (resta la vibrazione), come verificato nello spike del 12 ottobre;
  - con «non disturbare» l'avviso suona comunque: il timer l'ha avviato l'utente, e chi vuole silenzio ha il profilo silenzioso o il volume a zero. Lo stesso fa Minidoro. La descrizione del menu lo dice;
  - la notifica critica viene pubblicata una sola volta e senza suono (accende lo schermo e lascia la voce negli Eventi), come per la «Sveglia»;
  - col loop si ripete solo il suono, quindi il banner compare una sola volta.
- Il permesso Sailjail `Audio`, tolto nella release 14, torna nel `.desktop`. Minidoro lo usa ed è pubblicato su Harbour. Nessuno spike separato: la checklist sul telefono verifica che le notifiche restino negli Eventi (B11), il comportamento con «non disturbare», col profilo silenzioso e con lo schermo spento.

Fuori scope:
- Uno slider di volume dell'app: sarebbe solo una percentuale del volume Applicazioni (scartato dall'utente il 14 ottobre 2026).
- La scelta del suono.
- Un loop senza banner ripetuto per «Volume suoneria»: lì il suono lo riproduce la notifica stessa, e ripetere solo il suono disegnava un banner vuoto. Servirebbe un altro meccanismo (per esempio un evento `ngfd`), che non garantisce il rispetto di «non disturbare».

## Capabilities

### New Capabilities
<!-- Nessuna. -->

### Modified Capabilities
- `break-alerts`: cambia il requisito «Tipo di avviso» (con «Notifica», scelta tra volume Applicazioni, predefinito, e volume Suoneria; entrambi muti col profilo silenzioso, solo il volume Suoneria rispetta «non disturbare»). Il requisito «Ripetizione dell'avviso» resta valido così com'è.

## Impact

- `project_sailfish_os/qml/AlertPlayer.qml`: percorso `Audio` per la «Notifica» col volume Applicazioni (notifica senza suono, vibrazione, loop del suono).
- `qml/harbour-202020.qml` e `SettingsPage.qml`: nuova chiave dconf `notificationVolume` (`app` | `ringtone`, predefinita `app`) e menu.
- `harbour-202020.desktop`: permesso Sailjail `Audio`.
- `docs/sailfish.md` (chiave dconf), `docs/acceptance-checklist.md` (nuove righe), traduzioni.
- Nessuna nuova dipendenza: QtMultimedia è già ammesso in Harbour.
