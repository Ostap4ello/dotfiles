import QtQuick 2.0
import SddmComponents 2.0

//Connections {
//    target: sddm
//    function onLoginSucceeded() {
//        console.log("Login succeeded")
//    }
//
//    function onLoginFailed() {
//        //tVxtMessage.text = textConstants.loginFailed
//        //listView.currentItem.password = ""
//        console.log("Login failed")
//    }
//
//    function onInformationMessage(message) {
//        //txtMessage.text = message
//    }
//}

Row {
    id: loginPanel

    property real gScale: 1
    property int sessionIndex: 0

    spacing: config.spacing * gScale
    anchors.margins: config.spacing * gScale

    Column {
        id: fields
        spacing: config.spacing * gScale

        UserField {
            id: userField

            font.pixelSize: config.fieldHeight * 0.4 * gScale

            width: config.fieldWidth * gScale
            height: config.fieldHeight * gScale

            Keys.onPressed: function (event) {
                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                    pswdField.focus = true;
                }
            }
            KeyNavigation.backtab: idOfPrev; KeyNavigation.tab: pswdField
        }

        PswdField {
            id: pswdField

            font.pixelSize: config.fieldHeight * 0.4 * gScale

            width: config.fieldWidth * gScale
            height: config.fieldHeight * gScale

            Keys.onPressed: function (event) {
                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                    sddm.login(userField.text, pswdField.text, sessionIndex);
                }
            }
            KeyNavigation.backtab: userField; KeyNavigation.tab: loginBtn
        }
    }

    Button {
        id: loginBtn

        width: config.fieldHeight * gScale
        height:  2 * config.fieldHeight * gScale + config.spacing * globalScale
        text: ">"

        color: "#999999"
        pressedColor: "#111111"
        activeColor: "#999999"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                sddm.login(userField.text, pswdField.text, sessionIndex)
            }
        }
        Keys.onPressed: function (event) {
            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                sddm.login(userField.text, pswdField.text, sessionIndex);
            }
        }
        KeyNavigation.backtab: pswdField; KeyNavigation.tab: idOfNext
    }
}
