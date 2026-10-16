# Tasks

## 1. Chiavi dconf e clamp

- [x] 1.1 In `project_sailfish_os/qml/harbour-202020.qml` sostituire `workMinutes` e `testWorkSeconds` con `durationUnits` (stringa, predefinita `minutesAndSeconds`) e `workSeconds` (predefinita 1200), tenendo `breakSeconds` (predefinita 20), come da design D1; verificare con `grep -rn "workMinutes\|testWorkSeconds" project_sailfish_os` senza risultati
- [x] 1.2 Nel binding verso `CycleController` bloccare ogni durata ai limiti della sua unità nella modalità attiva (60–3600 s se in minuti, 5–120 s se in secondi), come da design D4; verificare leggendo il binding per le tre modalità

## 2. Pagina delle impostazioni

- [ ] 2.1 In `project_sailfish_os/qml/pages/SettingsPage.qml` aggiungere sopra gli slider il `ComboBox` «Units» con «Minutes and seconds», «Minutes and minutes», «Seconds and seconds»: indice iniziale letto in `Component.onCompleted`, salvataggio in `MenuItem.onClicked` solo se la modalità scelta è diversa da `durationUnits`, poi scrittura dei predefiniti della nuova modalità (design D3); verificare sul telefono che riselezionare la modalità attiva non cambi le durate
- [ ] 2.2 Mettere i due `StepSlider` in un `Loader` ricreato al cambio di modalità; ogni slider prende unità, intervallo e passo dalla sua unità (minuti 1–60 passo 1, mostra `secondi / 60` e salva `valore * 60`; secondi 5–120 passo 5), senza modificare `StepSlider.qml` (design D2, D3); verificare sul telefono che dopo il cambio di modalità gli slider mostrino subito i predefiniti della nuova modalità
- [ ] 2.3 Tradurre in italiano le nuove stringhe in `project_sailfish_os/translations/harbour-202020-it.ts` («Unità», «Minuti e secondi», «Minuti e minuti», «Secondi e secondi»); verificare dopo la build che il file non contenga voci `type="unfinished"`

## 3. Documentazione

- [x] 3.1 In `docs/sailfish.md` aggiornare la tabella delle chiavi (`durationUnits`, `workSeconds`, `breakSeconds` con i nuovi intervalli; rimuovere `workMinutes` e `testWorkSeconds`), sostituire la procedura di prova veloce con la modalità «Seconds and seconds» e aggiungere il `dconf reset -f` da lanciare dopo l'installazione di questa release (design D5); verificare con `grep -n "testWorkSeconds\|workMinutes" docs/sailfish.md` senza risultati
- [x] 3.2 In `docs/acceptance-checklist.md` sostituire il passo preliminare che azzera `testWorkSeconds` con `dconf reset -f /apps/harbour-202020/`, aggiornare l'esito atteso di A14 con la modalità «Minutes and seconds» e aggiungere righe con esito `-` per i nuovi scenari di `break-cycle` (intervalli in minuti, intervalli in secondi, cambio di modalità, riselezione della modalità attiva, cambio di modalità durante una fase); verificare con `grep -n testWorkSeconds docs/acceptance-checklist.md` senza risultati

## 4. Build e prova sul telefono

- [ ] 4.1 Portare `Release:` a 23 in `project_sailfish_os/rpm/harbour-202020.spec`, fare la build e il `check` di Harbour, copiare l'RPM sul telefono (l'utente lo installa e lancia `dconf reset -f /apps/harbour-202020/`); verificare che il `check` passi senza nuovi errori
- [ ] 4.2 Sul telefono eseguire A14, A15, A16 e le nuove righe della checklist, in italiano, e segnare gli esiti in `docs/acceptance-checklist.md`; verificare che siano tutti `OK`

## Workflow follow-up

- Archiviare la change con `/opsx:archive duration-units` dopo la prova sul telefono.
