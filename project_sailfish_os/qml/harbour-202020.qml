import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0
import "pages"
import "cover"

// Application window: owns the settings, the cycle and the alert, and passes
// them to the pages.
ApplicationWindow {
    id: app

    // Brings the app to the foreground on the main page, so the phase and the
    // main button are visible as soon as the alert starts. With the device
    // locked, the app is shown right after unlocking.
    function showMainPage() {
        if (pageStack.depth > 1)
            pageStack.pop(null, PageStackAction.Immediate)
        activate()
    }

    // Settings stored in dconf under /apps/harbour-202020.
    // Remove them with: dconf reset -f /apps/harbour-202020/
    ConfigurationGroup {
        id: appSettings
        path: "/apps/harbour-202020"
        // Units shown in the settings: "minutesAndSeconds" (work in minutes,
        // break in seconds) | "minutesAndMinutes" | "secondsAndSeconds".
        // Durations are always stored in seconds, whatever the units.
        property string durationUnits: "minutesAndSeconds"
        property int workSeconds: 1200
        property int breakSeconds: 20
        property string alertRepeat: "loop"         // "loop" | "once"
        // With the "loop" repeat, vibrate at every repeat, not only at the start.
        property bool loopVibration: false
        property string alertType: "sound"          // "sound" | "notification" | "alarm"
        property int alarmOnceSeconds: 30           // seconds, 5-60
    }

    // Keeps a stored duration inside the range of its unit, in case dconf
    // was edited by hand: 1-60 min, or 5-120 s.
    function clampDuration(seconds, inMinutes) {
        return inMinutes ? Math.max(60, Math.min(3600, seconds))
                         : Math.max(5, Math.min(120, seconds))
    }

    AlertPlayer {
        id: alertPlayer
        type: appSettings.alertType === "alarm" || appSettings.alertType === "notification"
              ? appSettings.alertType : "sound"
        repeat: appSettings.alertRepeat === "once" ? "once" : "loop"
        vibrateInLoop: appSettings.loopVibration
        alarmOnceSeconds: Math.max(5, Math.min(60, appSettings.alarmOnceSeconds))
    }

    CycleController {
        id: cycleController
        // Work is in minutes unless the units are "secondsAndSeconds"; break
        // only with "minutesAndMinutes". Same rule as in SettingsPage.
        workSeconds: app.clampDuration(appSettings.workSeconds,
                                       appSettings.durationUnits !== "secondsAndSeconds")
        breakSeconds: app.clampDuration(appSettings.breakSeconds,
                                        appSettings.durationUnits === "minutesAndMinutes")
        onPhaseFinished: {
            alertPlayer.start(phase)
            app.showMainPage()
        }
        // Stop: the alert must not outlive the phase that started it.
        onPhaseChanged: if (phase !== "workDone" && phase !== "breakDone") alertPlayer.stop()
    }

    initialPage: Component { MainPage { cycle: cycleController; settings: appSettings } }
    cover: Component { CoverPage { cycle: cycleController } }
    allowedOrientations: defaultAllowedOrientations
}
