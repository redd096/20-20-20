# Tasks

## 1. Repository

- [x] 1.1 Inizializzare git alla radice `app_20_20_20/` con `.gitignore` (`.claude/`, `build/`, `ssh/`), `LICENSE` GPLv3 e `README.md` con lo scopo e i link a `docs/` e al change; verificare che `git status` non elenchi `.claude/` ed elenchi `openspec/`
- [x] 1.2 Creare le cartelle `project_sailfish_os/` e `docs/` (con `docs/README.md` indice) e verificare che `openspec validate sailfish-mvp --strict` passi

## 2. Spike sul telefono (D4, D5)

- [x] 2.1 In `build/spike/` (ignorata da git) creare un'app QML minima con `KeepAlive` e un timer di 20 minuti calcolato su `endTime`; installarla, spegnere lo schermo e verificare che il suono parta entro 5 s dallo scadere; annotare la batteria consumata
- [x] 2.2 Nella stessa app provare i meccanismi di suono di D5 col profilo normale e col profilo silenzioso; verificare quale rispetta il silenzioso («Notifica») e quale suona comunque («Sveglia»)
- [x] 2.3 Eseguire `sfdk check` sull'RPM dello spike e verificare quali import usati sono ammessi in Harbour
- [x] 2.4 Scrivere `docs/sailfish-spike.md` con esiti e scelte, aggiornare D4/D5 in `design.md` e, se Harbour esclude «Sveglia», decidere con l'utente la strada indicata nei rischi prima di procedere col gruppo 6

## 3. Scheletro dell'app (D2, D8)

- [x] 3.1 Creare in `project_sailfish_os/` il template `sailfishapp` di D2 (`.pro`, launcher, `.desktop`, `rpm/harbour-202020.spec`, icone 86/108/128/172) e verificare che `sfdk build` produca l'RPM in `build/sailfish/`
- [x] 3.2 Scrivere `docs/sailfish.md` con build, installazione via ssh, rimozione (`rpm -e`, `dconf reset`) e spiegazione dei comandi; verificare installando l'RPM e vedendo l'app nel launcher, poi rimuovendolo e reinstallandolo seguendo il documento

## 4. Ciclo lavoro/pausa (break-cycle, D3)

- [x] 4.1 Implementare `CycleController.qml` con i 5 stati, `endTime`, `start()`/`confirm()`/`stop()` e il controllo della scadenza (durate fisse, avviso ancora assente); verificare sul telefono con durate temporanee di 1 min/5 s il percorso Fermo → Lavoro → Lavoro finito → Pausa → Pausa finita → Lavoro e lo Stop da ogni stato
- [x] 4.2 Implementare `MainPage.qml` (stato, tempo mm:ss, pulsante principale con le etichette della spec, Stop) e la cover passiva; verificare lo scenario «Ritorno all'app dopo lo schermo spento» e che il pulsante non sia disponibile durante le fasi in corso
- [x] 4.3 Aggiungere `KeepAlive` attivo solo durante le fasi in corso (D4); verificare che chiudendo l'app durante il lavoro non resti alcun processo (`ps` via ssh) e che non parta alcun avviso

## 5. Impostazioni (break-cycle, D6)

- [x] 5.1 Implementare `SettingsPage.qml` e il `ConfigurationGroup` per le durate (1–120 min, 5–300 s, predefinite 20/20); verificare i valori predefiniti, la persistenza dopo il riavvio dell'app e che una modifica durante una fase valga solo dalla fase successiva
- [x] 5.2 Aggiornare `docs/sailfish.md` con l'elenco delle chiavi dconf e verificare che `dconf reset -f /apps/harbour-202020/` riporti ai valori predefiniti

## 6. Avvisi (break-alerts, D5)

- [x] 6.1 Aggiungere l'avviso alla fine di ogni fase col meccanismo scelto nello spike (D5: suono di sistema, `PULSE_PROP` nel launcher, notifica critica), con vibrazione; verificare con schermo spento e app ridotta a icona che parta entro 5 s
- [x] 6.2 Aggiungere le impostazioni «Ripetizione» (Una volta/In loop) e «Tipo» (Notifica/Sveglia) con persistenza; estendere `KeepAlive` al loop; verificare gli scenari di `break-alerts` col profilo normale e col silenzioso, e che il loop si fermi subito con il pulsante principale e con Stop
- [x] 6.3 ~~Aggiungere l'impostazione «Volume sveglia» (5–100%, passi di 5, predefinita 100%) applicata al suono «Sveglia», con la chiave in `docs/sailfish.md`; verificare al 30% e al 100% che la differenza si senta e che il valore resti dopo il riavvio dell'app~~ Superato da 6.5: la «Sveglia» usa il volume della sveglia di sistema; al suo posto c'è «Durata sveglia» (5–60 s, predefinita 30) per «Una volta»

Stato al 13 ottobre 2026 (release `0.1.0-13`). 6.1–6.5 provati dall'utente sul telefono con la «Sveglia» via `ngfd` (strada «A»: resta compatibile col Jolla Store). La strada «B» (`timed` / `Nemo.Alarms`, solo OpenRepos) è un'idea per dopo.

- [x] 6.4 Mini-spike `ngfd`: da ssh, `gdbus call --system --dest com.nokia.NonGraphicFeedback1.Backend --object-path /com/nokia/NonGraphicFeedback1 --method com.nokia.NonGraphicFeedback1.Backend.Play clock "@a{sv} {}"` (la firma vera è `a{sv}`: `a(sv)` dell'introspezione fallisce), poi `Stop <id>`; verificare col profilo normale e col silenzioso che usi la suoneria della sveglia dell'utente e il volume di SpeakerGain, che vibri e che si fermi. Se funziona, provare la stessa chiamata dall'app con `Nemo.DBus 2.0` (ammesso in Harbour; il bus di sistema `com.nokia.NonGraphicFeedback1.Backend` è nel permesso Sailjail `Base`) e annotare gli esiti in `docs/sailfish-spike.md`
- [x] 6.5 Se 6.4 riesce: sostituire in `AlertPlayer.qml` il suono «Sveglia» con l'evento `ngfd` `clock` (eventualmente anche «Notifica» con un evento che segue il profilo), togliere `PULSE_PROP` dal launcher e lo slider del volume (aggiornando spec `break-alerts`, D5 e 6.3), e aggiornare `docs/`; verificare di nuovo gli scenari di `break-alerts`
- [x] 6.6 Loop del modo «Notifica»: tornare al banner che si ripete a ogni suono (scelta «A» dell'utente), togliendo il trucco di `previewSummary`/`previewBody` vuoti che disegna un banner bianco; verificare in loop che non compaia il banner bianco
- [x] 6.7 All'avviso portare l'app in primo piano (`activate()` della finestra) con lo stato e il pulsante principale ben visibili; verificare a telefono sbloccato e dopo lo sblocco
- [x] 6.8 Notifiche che non restano negli Eventi: dal 12 ottobre il sistema scarta le notifiche con `appName` «20-20-20», anche quelle inviate a mano via D-Bus, mentre accetta gli altri nomi. Con la release 9 funzionavano. Dopo 6.4, con il consenso dell'utente, riavviare la home (`systemctl --user restart lipstick`) e verificare se tornano; se no, indagare (per esempio `appName` uguale al nome del file `.desktop`). Esito: con la release 16 le notifiche sono tornate negli Eventi senza riavviare la home; causa non chiarita (forse la rilettura del `.desktop` all'aggiornamento, dopo la rimozione del permesso `Audio` nella release 14). Da ricontrollare nella checklist 9.1

## 7. Nuova macchina a stati (break-cycle, break-alerts, D3)

- [x] 7.1 Riscrivere `CycleController.qml` con le 6 fasi interne di D3, `confirm()`/`restartWork()`/`stop()`, `endTime` conservato dopo lo scadere e `overtimeSeconds`; verificare sul telefono con `testWorkSeconds` a 5 s il giro completo (Avvia → Lavoro scaduto → Stop → Inizia pausa → Pausa scaduta → Stop), «Riprendi lavoro», lo Stop a metà di ogni fase senza avvisi successivi e che `KeepAlive` sia attivo solo durante il conto alla rovescia
- [x] 7.2 Aggiornare `MainPage.qml` (nomi degli stati, solo «Stop» in «Lavoro» e «Pausa», «Inizia pausa» e «Riprendi lavoro» in «In attesa della pausa», 0:00 più il tempo in più rosso dopo 10 s con dissolvenza) e i testi della cover per i nuovi stati (oggi in «In attesa della pausa» mostrerebbe «Break finished»); verificare gli scenari «Risposta pronta» e «Ritorno dopo lo schermo spento» di «Tempo in più»
- [x] 7.3 Allineare `AlertPlayer.qml`, `harbour-202020.qml` e i testi della notifica: l'avviso si ferma solo con Stop e i testi restano coerenti col nuovo flusso; verificare gli scenari di `break-alerts` in loop con «Notifica» e con «Sveglia»

## 8. Lingue (D7)

- [x] 8.1 Generare e compilare le traduzioni italiano e inglese; verificare sul telefono con la lingua di sistema in italiano e in inglese che non restino stringhe non tradotte. Da rigenerare dopo il gruppo 7, perché le stringhe cambiano: la verifica sul telefono si fa una volta sola

  Esito (14 ottobre 2026, release 20): italiano verificato sul telefono. L'inglese, lingua dei sorgenti e fallback per le lingue senza traduzione, è controllato sul codice (tutte le stringhe passano da `qsTr()`, tranne il nome «20-20-20»); la prova sul telefono in inglese, che richiede un riavvio, passa nella checklist 9.1
- [x] 8.2 Ripetizione predefinita «In loop» al posto di «Una volta» (richiesta dell'utente del 14 ottobre 2026), in `harbour-202020.qml`, nella spec `break-alerts` e in `docs/sailfish.md`; la verifica dei valori predefiniti è nella checklist 9.1 (A14)

## 9. Verifica finale e pacchetto

- [ ] 9.1 Scrivere `docs/acceptance-checklist.md` con tutti gli scenari di `break-cycle` e `break-alerts`, più la prova dell'app con la lingua di sistema in inglese, ed eseguirla sul telefono con le durate predefinite (almeno un ciclo completo da 20 min a schermo spento), annotando gli esiti
- [ ] 9.2 Eseguire `sfdk check` sull'RPM finale e annotare in `docs/sailfish.md` se è pubblicabile nel Jolla Store, su OpenRepos o su entrambi; impostare la versione 0.1.0 e il tag `sailfish-v0.1.0`
