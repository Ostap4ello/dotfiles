import QtQuick 2.0
import SddmComponents 2.0

Row {
    property int sessionIndex: sessionBox.index
    property real gScale: 1
    property string idOfNext: ""
    property string idOfPrev: ""

    spacing: config.spacing
    anchors.margins: config.spacing

    DropUpBox {
        id: sessionBox
        width: config.fieldWidth * gScale 
        height: config.fieldHeight * gScale
        color: "white"
        opacity: 0.6

        arrowIcon: "qrc:///theme/angle-down.png"

        model: sessionModel
        index: sessionModel.lastIndex

        font.pixelSize: config.field_height * 0.4 * gScale
        KeyNavigation.backtab: idOfPrev; KeyNavigation.tab: buttonReboot
    }

    Button {
        id: buttonReboot

        width: config.buttonSize * gScale
        height: config.buttonSize * gScale
        color: "white"
        opacity: 0.6
        text: "R"
        textColor: "black"
        font {
            bold: false
            pixelSize: config.buttonSize * 0.4 * gScale
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                sddm.reboot()
            }
        }
        KeyNavigation.backtab: sessionBox; KeyNavigation.tab: buttonPoweroff
    }

    Button {
        id: buttonPoweroff

        width: config.buttonSize * gScale
        height: config.buttonSize * gScale
        color: "red"
        opacity: 0.6
        text: "P"
        font {
            bold: false
            pixelSize: config.buttonSize * 0.4 * gScale
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                sddm.powerOff()
            }
        }
        KeyNavigation.backtab: buttonReboot; KeyNavigation.tab: idOfNext
    }

}
