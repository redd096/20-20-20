import QtQuick 2.0
import Nemo.KeepAlive 1.2

// Work/break cycle of the 20-20-20 rule (spec "break-cycle").
//
// Phases:
//   "idle"      - stopped, waiting for Start
//   "working"   - work countdown running
//   "workDone"  - work finished, waiting for the user to start the break
//   "onBreak"   - break countdown running
//   "breakDone" - break finished, waiting for the user to resume work
//
// Every transition between phases needs a user confirmation, except the
// end of a countdown.
Item {
    id: cycle

    // Durations are read when a phase starts, so a change made during a
    // phase only applies from the next one.
    property int workSeconds: 20 * 60
    property int breakSeconds: 20

    property string phase: "idle"
    // End time of the running countdown, in ms since the epoch. The remaining
    // time is always computed from it, so it stays correct after the device
    // has been suspended or the app minimized.
    property double endTime: 0
    property int remainingSeconds: 0

    // True while a countdown is running.
    readonly property bool counting: phase === "working" || phase === "onBreak"
    // Remaining time formatted as m:ss.
    readonly property string remainingText: Math.floor(remainingSeconds / 60) + ":"
                                            + ("0" + remainingSeconds % 60).slice(-2)

    // Emitted when a countdown ends, with the new phase ("workDone" or "breakDone").
    signal phaseFinished(string phase)

    // Main button: starts work from "idle" or "breakDone", starts the break
    // from "workDone". Does nothing while a countdown is running.
    function confirm() {
        if (phase === "idle" || phase === "breakDone")
            begin("working", workSeconds)
        else if (phase === "workDone")
            begin("onBreak", breakSeconds)
    }

    // Stop button: cancels everything and goes back to "idle".
    function stop() {
        expiry.stop()
        endTime = 0
        remainingSeconds = 0
        phase = "idle"
    }

    // Starts a countdown of the given length for the given phase.
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

    // Moves to the "done" phase once the end time has passed.
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

    // Fires at the expected end time.
    Timer {
        id: expiry
        repeat: false
        onTriggered: cycle.checkExpiry()
    }
    // Updates the UI every second and acts as a fallback if the timer above
    // fires a little early.
    Timer {
        interval: 1000
        repeat: true
        running: cycle.counting
        onTriggered: cycle.checkExpiry()
    }

    // Prevents CPU suspend only while a countdown is running, otherwise the
    // timers would stop with the screen off.
    KeepAlive {
        enabled: cycle.counting
    }
}
