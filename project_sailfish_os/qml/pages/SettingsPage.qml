import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    // ConfigurationGroup dell'app (D6): le modifiche si salvano subito.
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
        }
        VerticalScrollDecorator {}
    }
}
