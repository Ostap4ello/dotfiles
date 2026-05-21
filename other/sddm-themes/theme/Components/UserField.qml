//import QtGraphicalEffects 1.12
import QtQuick 2.15
import QtQuick.Controls 2.15

TextField {
    selectByMouse: true

    font {
        family: config.fontFamily
        bold: true
    }

    text: userModel.lastUser
    //placeholderText: config.UserPlaceholderText
    horizontalAlignment: Text.AlignHCenter

    color: "black"
    //selectionColor: config.InputTextColor
    //renderType: Text.NativeRendering
 
    //states: [
    //    State {
    //        name: "focused"
    //        when: usernameField.activeFocus
    //
    //        PropertyChanges {
    //            target: userFieldBackground
    //            color: Qt.darker(config.InputColor, 1.2)
    //            //border.width: config.InputBorderWidth
    //        }
    //    },
    //    State {
    //        name: "hovered"
    //        when: usernameField.hovered
    //
    //        PropertyChanges {
    //            target: userFieldBackground
    //            color: Qt.darker(config.InputColor, 1.2)
    //        }
    //    }
    //]

    background: Rectangle {
        id: userFieldBackground

        color: "white"
        //border.color: config.InputBorderColor
        border.width: 0
        //radius: config.Radius
    }

    //transitions: Transition {
    //    PropertyAnimation {
    //        properties: "color, border.width"
    //        duration: 150
    //    }
    //}
}

