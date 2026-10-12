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

- [ ] 5.1 Implementare `SettingsPage.qml` e il `ConfigurationGroup` per le durate (1–120 min, 5–300 s, predefinite 20/20); verificare i valori predefiniti, la persistenza dopo il riavvio dell'app e che una modifica durante una fase valga solo dalla fase successiva
- [ ] 5.2 Aggiornare `docs/sailfish.md` con l'elenco delle chiavi dconf e verificare che `dconf reset -f /apps/harbour-202020/` riporti ai valori predefiniti

## 6. Avvisi (break-alerts, D5)

- [ ] 6.1 Aggiungere l'avviso alla fine di ogni fase col meccanismo scelto nello spike (D5: suono di sistema, `PULSE_PROP` nel launcher, notifica critica), con vibrazione; verificare con schermo spento e app ridotta a icona che parta entro 5 s
- [ ] 6.2 Aggiungere le impostazioni «Ripetizione» (Una volta/In loop) e «Tipo» (Notifica/Sveglia) con persistenza; estendere `KeepAlive` al loop; verificare gli scenari di `break-alerts` col profilo normale e col silenzioso, e che il loop si fermi subito con il pulsante principale e con Stop

## 7. Lingue (D7)

- [ ] 7.1 Generare e compilare le traduzioni italiano e inglese; verificare sul telefono con la lingua di sistema in italiano e in inglese che non restino stringhe non tradotte

## 8. Verifica finale e pacchetto

- [ ] 8.1 Scrivere `docs/acceptance-checklist.md` con tutti gli scenari di `break-cycle` e `break-alerts` ed eseguirla sul telefono con le durate predefinite (almeno un ciclo completo da 20 min a schermo spento), annotando gli esiti
- [ ] 8.2 Eseguire `sfdk check` sull'RPM finale e annotare in `docs/sailfish.md` se è pubblicabile nel Jolla Store, su OpenRepos o su entrambi; impostare la versione 0.1.0 e il tag `sailfish-v0.1.0`
