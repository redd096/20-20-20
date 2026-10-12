import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    property var cycle
    property var settings

    allowedOrientations: Orientation.All

    function phaseText(phase) {
        switch (phase) {
        case "working": return qsTr("Working")
        case "workDone": return qsTr("Work finished")
        case "onBreak": return qsTr("On break")
        case "breakDone": return qsTr("Break finished")
        default: return qsTr("Stopped")
        }
    }

    function buttonText(phase) {
        switch (phase) {
        case "workDone": return qsTr("Start break")
        case "breakDone": return qsTr("Resume")
        default: return qsTr("Start")
        }
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        PullDownMenu {
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("SettingsPage.qml"), { settings: page.settings })
            }
        }

        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingLarge

            PageHeader { title: "20-20-20" }

            Label {
                width: parent.width - 2 * Theme.horizontalPageMargin
                x: Theme.horizontalPageMargin
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap
                text: page.phaseText(page.cycle.phase)
                color: Theme.highlightColor
                font.pixelSize: Theme.fontSizeLarge
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                visible: page.cycle.counting
                text: page.cycle.remainingText
                font.pixelSize: Theme.fontSizeHuge * 2
            }

            Item { width: 1; height: Theme.paddingLarge }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                visible: !page.cycle.counting
                preferredWidth: Theme.buttonWidthLarge
                text: page.buttonText(page.cycle.phase)
                onClicked: page.cycle.confirm()
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                visible: page.cycle.phase !== "idle"
                preferredWidth: Theme.buttonWidthMedium
                text: qsTr("Stop")
                onClicked: page.cycle.stop()
            }
        }
    }
}
