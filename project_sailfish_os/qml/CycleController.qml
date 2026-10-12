import QtQuick 2.0
import Nemo.KeepAlive 1.2

// Ciclo lavoro/pausa della spec break-cycle. Le fasi si chiamano:
// "idle" (Fermo), "working" (Lavoro in corso), "workDone" (Lavoro finito),
// "onBreak" (Pausa in corso), "breakDone" (Pausa finita).
Item {
    id: cycle

    // Durate lette all'inizio di ogni fase: una modifica vale dalla successiva.
    property int workSeconds: 20 * 60
    property int breakSeconds: 20

    property string phase: "idle"
    // Istante di fine della fase in corso (ms dall'epoch). Il tempo rimanente
    // si ricava sempre da qui, così resta giusto dopo un suspend.
    property double endTime: 0
    property int remainingSeconds: 0

    readonly property bool counting: phase === "working" || phase === "onBreak"
    readonly property string remainingText: Math.floor(remainingSeconds / 60) + ":"
                                            + ("0" + remainingSeconds % 60).slice(-2)

    // Emesso quando una fase scade, con la nuova fase ("workDone" o "breakDone").
    signal phaseFinished(string phase)

    // Pulsante principale: avvia il lavoro da Fermo o da Pausa finita,
    // avvia la pausa da Lavoro finito. Durante il conto alla rovescia non fa nulla.
    function confirm() {
        if (phase === "idle" || phase === "breakDone")
            begin("working", workSeconds)
        else if (phase === "workDone")
            begin("onBreak", breakSeconds)
    }

    function stop() {
        expiry.stop()
        endTime = 0
        remainingSeconds = 0
        phase = "idle"
    }

    function begin(nextPhase, seconds) {
        endTime = Date.now() + seconds * 1000
        phase = nextPhase
        updateRemaining()
        expiry.interval = seconds * 1000
        expiry.restart()
    }

    function updateRemaining() {
        remainingSeconds = Math.max(0, Math.ceil((endTime - Date.now()) / 1000))
    }

    function checkExpiry() {
        if (!counting)
            return
        updateRemaining()
        if (Date.now() < endTime)
            return
        expiry.stop()
        endTime = 0
        phase = phase === "working" ? "workDone" : "breakDone"
        phaseFinished(phase)
    }

    // Scatta allo scadere previsto; il tick da 1 s aggiorna la UI e fa da riserva.
    Timer {
        id: expiry
        repeat: false
        onTriggered: cycle.checkExpiry()
    }
    Timer {
        interval: 1000
        repeat: true
        running: cycle.counting
        onTriggered: cycle.checkExpiry()
    }

    // Impedisce il suspend della CPU solo durante il conto alla rovescia (D4).
    KeepAlive {
        enabled: cycle.counting
    }
}
