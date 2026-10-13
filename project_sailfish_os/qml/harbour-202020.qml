import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0
import "pages"
import "cover"

// Application window: owns the settings, the cycle and the alert, and passes
// them to the pages.
ApplicationWindow {
    // Settings stored in dconf under /apps/harbour-202020.
    // Remove them with: dconf reset -f /apps/harbour-202020/
    ConfigurationGroup {
        id: appSettings
        path: "/apps/harbour-202020"
        property int workMinutes: 20
        property int breakSeconds: 20
        property string alertRepeat: "once"         // "once" | "loop"
        property string alertType: "notification"   // "notification" | "alarm"
        property int alarmVolume: 100               // percent, 5-100
    }

    AlertPlayer {
        id: alertPlayer
        type: appSettings.alertType === "alarm" ? "alarm" : "notification"
        repeat: appSettings.alertRepeat === "loop" ? "loop" : "once"
        alarmVolume: Math.max(5, Math.min(100, appSettings.alarmVolume))
    }

    CycleController {
        id: cycleController
        // Clamp the stored values, in case dconf was edited by hand.
        workSeconds: Math.max(1, Math.min(120, appSettings.workMinutes)) * 60
        breakSeconds: Math.max(5, Math.min(300, appSettings.breakSeconds))
        onPhaseFinished: alertPlayer.start(phase)
        // Confirm or Stop: the alert must not outlive the phase that started it.
        onPhaseChanged: if (phase !== "workDone" && phase !== "breakDone") alertPlayer.stop()
    }

    initialPage: Component { MainPage { cycle: cycleController; settings: appSettings; alert: alertPlayer } }
    cover: Component { CoverPage { cycle: cycleController } }
    allowedOrientations: defaultAllowedOrientations
}
