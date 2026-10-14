import QtQuick 2.0
import Sailfish.Silica 1.0

// Settings page: phase durations and alert options.
Page {
    id: page

    // The app ConfigurationGroup: every change is saved to dconf right away.
    property var settings

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

            ComboBox {
                id: typeBox
                label: qsTr("Type")
                description: currentIndex === 1
                             ? qsTr("Uses your alarm tone and alarm volume, even in silent mode and do not disturb.")
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

            // The system alarm repeats until it is stopped, so "Once" needs a
            // length. It fades in over the first 20 seconds.
            StepSlider {
                visible: typeBox.currentIndex === 1 && repeatBox.currentIndex === 0
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
