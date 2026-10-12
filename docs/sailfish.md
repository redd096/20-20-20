# 20-20-20 per Sailfish OS: build, installazione e rimozione

Sorgenti in `project_sailfish_os/`, pacchetto `harbour-202020`. Gli output di build vanno in `build/sailfish/`, esclusa da git.

## Requisiti

- Sailfish SDK in `~/SailfishOS/` con il target `SailfishOS-5.1.0.11-aarch64` (lo stesso di `keyboard_jolla`).
- Docker, avviato solo per la build.
- Accesso ssh al telefono con la configurazione di `keyboard_jolla`: `../keyboard_jolla/ssh/jolla.conf`. Non va copiata in questo repository.

## Build

Dalla radice del progetto:

```sh
sudo systemctl start docker
mkdir -p build/sailfish && cd build/sailfish
sg docker -c "~/SailfishOS/bin/sfdk -c target=SailfishOS-5.1.0.11-aarch64 -c no-fix-version build ../../project_sailfish_os"
sg docker -c "~/SailfishOS/bin/sfdk -c target=SailfishOS-5.1.0.11-aarch64 check RPMS/harbour-202020-[0-9]*.aarch64.rpm"
cd ../..
sudo systemctl stop docker
```

- `systemctl start/stop docker` accende Docker solo per la durata della build e poi lo spegne.
- `sg docker -c "…"` esegue il comando col gruppo `docker`, che serve a `sfdk`.
- `-c target=…` sceglie il target, `-c no-fix-version` usa la versione scritta nel `.spec` invece di ricavarla dai tag git.
- `sfdk build` compila in `build/sailfish/` e crea l'RPM in `build/sailfish/RPMS/`.
- `sfdk check` esegue la validazione del Jolla Store (Harbour). Deve terminare con `Validation succeeded`.

## Installazione

```sh
scp -F ../keyboard_jolla/ssh/jolla.conf build/sailfish/RPMS/harbour-202020-[0-9]*.aarch64.rpm jolla:/home/defaultuser/
ssh -t -F ../keyboard_jolla/ssh/jolla.conf jolla "devel-su rpm -Uvh /home/defaultuser/harbour-202020-[0-9]*.aarch64.rpm"
```

- `scp` copia l'RPM nella home del telefono.
- `ssh -t` apre un terminale interattivo, perché `devel-su` chiede la password di root del telefono.
- `rpm -Uvh` installa il pacchetto o aggiorna quello già presente.

L'app «20-20-20» compare nel launcher.

## Impostazioni salvate

L'app salva le impostazioni in dconf, sotto `/apps/harbour-202020/`. Una chiave assente vale come il suo valore predefinito.

| Chiave | Valori | Predefinito |
| --- | --- | --- |
| `workMinutes` | durata del lavoro, minuti interi da 1 a 120 | 20 |
| `breakSeconds` | durata della pausa, secondi interi da 5 a 300 | 20 |

Per leggerle o riportarle ai valori predefiniti, senza root:

```sh
ssh -F ../keyboard_jolla/ssh/jolla.conf jolla "dconf dump /apps/harbour-202020/"
ssh -F ../keyboard_jolla/ssh/jolla.conf jolla "dconf reset -f /apps/harbour-202020/"
```

- `dconf dump` mostra tutte le chiavi salvate dall'app.
- `dconf reset -f` le cancella tutte: alla riapertura l'app riparte coi valori predefiniti.

## Rimozione

```sh
ssh -t -F ../keyboard_jolla/ssh/jolla.conf jolla "devel-su rpm -e harbour-202020; rm -f /home/defaultuser/harbour-202020-[0-9]*.rpm; dconf reset -f /apps/harbour-202020/"
```

- `rpm -e` disinstalla il pacchetto: programma, QML, icone e voce del launcher.
- `rm -f` cancella l'RPM copiato in precedenza.
- `dconf reset -f` cancella le impostazioni salvate dall'app.

Dopo questi comandi sul telefono non resta niente dell'app. L'app non installa servizi né avvii automatici.
