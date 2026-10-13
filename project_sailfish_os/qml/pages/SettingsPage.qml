import QtQuick 2.0
import Sailfish.Silica 1.0

// Settings page: phase durations and alert options.
Page {
    id: page

    // The app ConfigurationGroup: every change is saved to dconf right away.
    property var settings
    // AlertPlayer, used to preview the alarm volume.
    property var alert

    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            width: parent.width

            PageHeader { title: qsTr("Settings") }

            SectionHeader { text: qsTr("Durations") }

            StepSlider {
                minimumValue: 1
                maximumValue: 120
                initialValue: page.settings.workMinutes
                unit: qsTr("min")
                label: qsTr("Work")
                onEdited: page.settings.workMinutes = newValue
            }

            StepSlider {
                minimumValue: 5
                maximumValue: 300
                initialValue: page.settings.breakSeconds
                unit: qsTr("s")
                label: qsTr("Break")
                onEdited: page.settings.breakSeconds = newValue
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
                label: qsTr("Repeat")
                Component.onCompleted: currentIndex = page.settings.alertRepeat === "loop" ? 1 : 0
                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("Once")
                        onClicked: page.settings.alertRepeat = "once"
                    }
                    MenuItem {
                        text: qsTr("Loop until confirmed")
                        onClicked: page.settings.alertRepeat = "loop"
                    }
                }
            }

            ComboBox {
                id: typeBox
                label: qsTr("Type")
                description: currentIndex === 1
                             ? qsTr("Rings like the alarm clock, even in silent mode and do not disturb, at full volume.")
                             : qsTr("Follows the ringtone volume, silent mode and do not disturb.")
                Component.onCompleted: currentIndex = page.settings.alertType === "alarm" ? 1 : 0
                menu: ContextMenu {
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

            // The alarm stream ignores the system alarm volume (see
            // docs/sailfish-spike.md), so the app has its own volume.
            StepSlider {
                visible: typeBox.currentIndex === 1
                minimumValue: 5
                maximumValue: 100
                stepSize: 5
                initialValue: page.settings.alarmVolume
                unit: "%"
                label: qsTr("Alarm volume")
                onEdited: {
                    page.settings.alarmVolume = newValue
                    // Let the user hear the new volume right away.
                    page.alert.preview(newValue)
                }
            }
        }
        VerticalScrollDecorator {}
    }
}
