import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0
import "pages"
import "cover"

ApplicationWindow {
    // Impostazioni salvate in dconf (D6); si cancellano con
    // dconf reset -f /apps/harbour-202020/
    ConfigurationGroup {
        id: appSettings
        path: "/apps/harbour-202020"
        property int workMinutes: 20
        property int breakSeconds: 20
    }

    CycleController {
        id: cycleController
        workSeconds: Math.max(1, Math.min(120, appSettings.workMinutes)) * 60
        breakSeconds: Math.max(5, Math.min(300, appSettings.breakSeconds))
    }

    initialPage: Component { MainPage { cycle: cycleController; settings: appSettings } }
    cover: Component { CoverPage { cycle: cycleController } }
    allowedOrientations: defaultAllowedOrientations
}
