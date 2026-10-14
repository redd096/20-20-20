import QtQuick 2.0
import Nemo.KeepAlive 1.2

// Work/break cycle of the 20-20-20 rule (spec "break-cycle").
//
// Internal phases (the page groups them into four visible states):
//   "waitWork"  - waiting for the user to start work        -> "Waiting for work"
//   "working"   - work countdown running                    -> "Work", running
//   "workDone"  - work countdown expired, alert playing     -> "Work", expired
//   "waitBreak" - waiting for the user to start the break   -> "Waiting for break"
//   "onBreak"   - break countdown running                   -> "Break", running
//   "breakDone" - break countdown expired, alert playing    -> "Break", expired
//
// Transitions:
//   confirm()     waitWork  -> working     waitBreak -> onBreak
//   restartWork() waitBreak -> working
//   stop()        working, workDone -> waitBreak
//                 onBreak, breakDone -> waitWork
//   end of time   working -> workDone      onBreak -> breakDone
//
// Every transition needs a user action, except the end of a countdown.
Item {
    id: cycle

    // Durations are read when a phase starts, so a change made during a
    // phase only applies from the next one.
    property int workSeconds: 20 * 60
    property int breakSeconds: 20

    property string phase: "waitWork"
    // End time of the current countdown, in ms since the epoch. It is kept
    // after the countdown expires, so the overtime can be computed from it.
    // Remaining time and overtime are always computed from it, so they stay
    // correct after the device has been suspended or the app minimized.
    property double endTime: 0
    property int remainingSeconds: 0
    // Seconds elapsed since the countdown expired, 0 when not expired.
    property int overtimeSeconds: 0

    // True while a countdown is running.
    readonly property bool counting: phase === "working" || phase === "onBreak"
    // True after a countdown has expired, until the user presses Stop.
    readonly property bool expired: phase === "workDone" || phase === "breakDone"
    // True in the two work phases and in the two break phases.
    readonly property bool inWork: phase === "working" || phase === "workDone"
    readonly property bool inBreak: phase === "onBreak" || phase === "breakDone"
    // Remaining time and overtime formatted as m:ss.
    readonly property string remainingText: formatTime(remainingSeconds)
    readonly property string overtimeText: "-" + formatTime(overtimeSeconds)

    // Emitted when a countdown ends, with the new phase ("workDone" or "breakDone").
    signal phaseFinished(string phase)

    // Main button of the two waiting states: starts work from "waitWork",
    // starts the break from "waitBreak". Does nothing in the other phases.
    function confirm() {
        if (phase === "waitWork")
            begin("working", workSeconds)
        else if (phase === "waitBreak")
            begin("onBreak", breakSeconds)
    }

    // Second button of "waitBreak": skips the break and starts work again.
    function restartWork() {
        if (phase === "waitBreak")
            begin("working", workSeconds)
    }

    // Stop button: ends the current phase, running or expired, and moves to
    // the next waiting state. Does nothing in the waiting states.
    function stop() {
        if (inWork)
            finish("waitBreak")
        else if (inBreak)
            finish("waitWork")
    }

    // Starts a countdown of the given length for the given phase.
    function begin(nextPhase, seconds) {
        endTime = Date.now() + seconds * 1000
        overtimeSeconds = 0
        phase = nextPhase
        updateTimes()
        expiry.interval = seconds * 1000
        expiry.restart()
    }

    // Cancels the countdown and moves to the given waiting state.
    function finish(nextPhase) {
        expiry.stop()
        endTime = 0
        remainingSeconds = 0
        overtimeSeconds = 0
        phase = nextPhase
    }

    // Recomputes remaining time and overtime from endTime.
    function updateTimes() {
        var now = Date.now()
        remainingSeconds = Math.max(0, Math.ceil((endTime - now) / 1000))
        overtimeSeconds = expired ? Math.max(0, Math.floor((now - endTime) / 1000)) : 0
    }

    // Moves to the expired phase once the end time has passed.
    function checkExpiry() {
        updateTimes()
        if (!counting || Date.now() < endTime)
            return
        expiry.stop()
        phase = phase === "working" ? "workDone" : "breakDone"
        updateTimes()
        phaseFinished(phase)
    }

    // Formats a number of seconds as m:ss.
    function formatTime(seconds) {
        return Math.floor(seconds / 60) + ":" + ("0" + seconds % 60).slice(-2)
    }

    // Fires at the expected end time.
    Timer {
        id: expiry
        repeat: false
        onTriggered: cycle.checkExpiry()
    }
    // Updates the UI every second, during a countdown and while expired (for
    // the overtime), and acts as a fallback if the timer above fires a little
    // early. While expired it does not keep the device awake: with the screen
    // off it simply pauses, and the overtime is right again at the next tick.
    Timer {
        interval: 1000
        repeat: true
        running: cycle.counting || cycle.expired
        triggeredOnStart: true
        onTriggered: cycle.checkExpiry()
    }

    // Prevents CPU suspend only while a countdown is running, otherwise the
    // timers would stop with the screen off.
    KeepAlive {
        enabled: cycle.counting
    }
}
