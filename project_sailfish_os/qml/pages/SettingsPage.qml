import QtQuick 2.0
import Sailfish.Silica 1.0

// Settings page: phase durations and alert options.
Page {
    id: page

    // The app ConfigurationGroup: every change is saved to dconf right away.
    property var settings

    // Which duration is shown in minutes: work unless the units are
    // "secondsAndSeconds", break only with "minutesAndMinutes".
    // Same rule as the clamp in harbour-202020.qml.
    readonly property bool workInMinutes: settings.durationUnits !== "secondsAndSeconds"
    readonly property bool breakInMinutes: settings.durationUnits === "minutesAndMinutes"

    // Saves new units with their default durations (in seconds). Picking the
    // units already in use changes nothing.
    function setUnits(units, workSeconds, breakSeconds) {
        if (units === settings.durationUnits)
            return
        settings.durationUnits = units
        settings.workSeconds = workSeconds
        settings.breakSeconds = breakSeconds
        // StepSlider reads its value only when created: recreate both sliders
        // so they show the new units and defaults right away.
        durationSliders.active = false
        durationSliders.active = true
    }

    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            width: parent.width

            PageHeader { title: qsTr("Settings") }

            SectionHeader { text: qsTr("Durations") }

            // Like the other menus: read once, saved when the user picks an entry.
            ComboBox {
                label: qsTr("Units")
                Component.onCompleted: currentIndex = page.settings.durationUnits === "minutesAndMinutes" ? 1
                                                    : page.settings.durationUnits === "secondsAndSeconds" ? 2 : 0
                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("Minutes and seconds")
                        onClicked: page.setUnits("minutesAndSeconds", 20 * 60, 20)
                    }
                    MenuItem {
                        text: qsTr("Minutes and minutes")
                        onClicked: page.setUnits("minutesAndMinutes", 25 * 60, 5 * 60)
                    }
                    MenuItem {
                        text: qsTr("Seconds and seconds")
                        onClicked: page.setUnits("secondsAndSeconds", 20, 20)
                    }
                }
            }

            // Durations are stored in seconds. A slider in minutes goes from
            // 1 to 60 in steps of 1; a slider in seconds from 5 to 120 in steps of 5.
            Loader {
                id: durationSliders
                width: parent.width
                sourceComponent: Column {
                    width: parent.width

                    StepSlider {
                        readonly property bool inMinutes: page.workInMinutes
                        minimumValue: inMinutes ? 1 : 5
                        maximumValue: inMinutes ? 60 : 120
                        stepSize: inMinutes ? 1 : 5
                        initialValue: inMinutes ? Math.round(page.settings.workSeconds / 60)
                                                : page.settings.workSeconds
                        unit: inMinutes ? qsTr("min") : qsTr("s")
                        label: qsTr("Work")
                        onEdited: page.settings.workSeconds = inMinutes ? newValue * 60 : newValue
                    }

                    StepSlider {
                        readonly property bool inMinutes: page.breakInMinutes
                        minimumValue: inMinutes ? 1 : 5
                        maximumValue: inMinutes ? 60 : 120
                        stepSize: inMinutes ? 1 : 5
                        initialValue: inMinutes ? Math.round(page.settings.breakSeconds / 60)
                                                : page.settings.breakSeconds
                        unit: inMinutes ? qsTr("min") : qsTr("s")
                        label: qsTr("Break")
                        onEdited: page.settings.breakSeconds = inMinutes ? newValue * 60 : newValue
                    }
                }
            }

            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                wrapMode: Text.Wrap
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeSmall
                text: qsTr("Changes apply from the next phase.")
            }

            SectionHeader { text: qsTr("Alert") }

            // Like the sliders: read once, saved when the user picks an entry.
            ComboBox {
                id: repeatBox
                label: qsTr("Repeat")
                Component.onCompleted: currentIndex = page.settings.alertRepeat === "once" ? 0 : 1
                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("Once")
                        onClicked: page.settings.alertRepeat = "once"
                    }
                    MenuItem {
                        text: qsTr("Loop until stopped")
                        onClicked: page.settings.alertRepeat = "loop"
                    }
                }
            }

            // Menu order: "sound", "notification", "alarm". Each description
            // says how the alert sounds and what its limits are.
            ComboBox {
                id: typeBox
                label: qsTr("Type")
                description: currentIndex === 2
                             ? qsTr("Uses your alarm tone and alarm volume, even in silent mode and do not disturb.")
                             : currentIndex === 1
                               ? qsTr("A system notification on the ringtone volume. Silent in silent mode and do not disturb. With the loop, the banner is shown again at every repeat.")
                               : qsTr("Played by the app on the media volume, set with the volume keys while the app is open. Silent in silent mode and do not disturb.")
                Component.onCompleted: currentIndex = page.settings.alertType === "alarm" ? 2
                                                    : page.settings.alertType === "notification" ? 1 : 0
                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("Sound")
                        onClicked: page.settings.alertType = "sound"
                    }
                    MenuItem {
                        text: qsTr("Notification")
                        onClicked: page.settings.alertType = "notification"
                    }
                    MenuItem {
                        text: qsTr("Alarm")
                        onClicked: page.settings.alertType = "alarm"
                    }
                }
            }

            // Only for "Sound" and "Notification" in a loop: the alarm uses the
            // vibration of the system alarm. The click flips the stored value
            // itself (automaticCheck off), so the order of Silica's own
            // handlers does not matter.
            TextSwitch {
                visible: repeatBox.currentIndex === 1 && typeBox.currentIndex !== 2
                text: qsTr("Vibrate at every repeat")
                description: qsTr("Also in silent mode and do not disturb, when the sound is muted.")
                automaticCheck: false
                checked: page.settings.loopVibration
                onClicked: page.settings.loopVibration = !checked
            }

            // The system alarm repeats until it is stopped, so "Once" needs a
            // length. It fades in over the first 20 seconds.
            StepSlider {
                visible: typeBox.currentIndex === 2 && repeatBox.currentIndex === 0
                minimumValue: 5
                maximumValue: 60
                stepSize: 5
                initialValue: page.settings.alarmOnceSeconds
                unit: qsTr("s")
                label: qsTr("Alarm length")
                onEdited: page.settings.alarmOnceSeconds = newValue
            }
        }
        VerticalScrollDecorator {}
    }
}
