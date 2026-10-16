# Tasks

## 1. Verifica delle spec divise

- [ ] 1.1 Confrontare ogni requisito diviso con la versione in `openspec/specs/` e verificare che ogni frase tolta compaia, con lo stesso significato, in uno dei requisiti nuovi, e che nessuno scenario esistente sia sparito
- [ ] 1.2 Verificare con `openspec validate split-long-requirements --strict` che la change sia valida senza avvisi sulla lunghezza

## Workflow follow-up

- Archiviare la change con `/opsx:archive split-long-requirements`.
- Dopo l'archiviazione verificare con `openspec validate break-cycle --type spec --strict` e `openspec validate break-alerts --type spec --strict` che le spec principali non abbiano più avvisi.
