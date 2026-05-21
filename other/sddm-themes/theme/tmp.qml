
Rectangle {
    anchors.fill: parent
    color: "transparent"
    //visible: primaryScreen

    Component {
        id: userDelegate

        PictureBox {
            anchors.verticalCenter: parent.verticalCenter
            name: (model.realName === "") ? model.name : model.realName
            icon: model.icon
            showPassword: model.needsPassword

            focus: (listView.currentIndex === index) ? true : false
            state: (listView.currentIndex === index) ? "active" : ""

            onLogin: sddm.login(model.name, password, sessionIndex);

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    listView.currentIndex = index;
                    listView.focus = true;
                }
            }
        }
    }

    Row {
        anchors.fill: parent
        //visible: primaryScreen

        Rectangle {
            width: parent.width / 2; height: parent.height
            color: "#00000000"

            Clock {
                id: clock
                anchors.centerIn: parent
                color: "white"
                timeFont.family: "Oxygen"
            }
        }

        Rectangle {
            width: parent.width / 2; height: parent.height
            color: "#22000000"
            clip: true

            Item {
                id: usersContainer
                width: parent.width; height: 300
                anchors.verticalCenter: parent.verticalCenter

                ImageButton {
                    id: prevUser
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.margins: 10
                    source: "qrc:///theme/angle-left.png"
                    onClicked: listView.decrementCurrentIndex()

                    KeyNavigation.backtab: btnShutdown; KeyNavigation.tab: listView
                }

                ListView {
                    id: listView
                    height: parent.height
                    anchors.left: prevUser.right; anchors.right: nextUser.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.margins: 10

                    clip: true
                    focus: true

                    spacing: 5

                    model: userModel
                    delegate: userDelegate
                    orientation: ListView.Horizontal
                    currentIndex: userModel.lastIndex

                    KeyNavigation.backtab: prevUser; KeyNavigation.tab: nextUser
                }

                ImageButton {
                    id: nextUser
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.margins: 10
                    source: "qrc:///theme/angle-right.png"
                    onClicked: listView.incrementCurrentIndex()
                    KeyNavigation.backtab: listView; KeyNavigation.tab: session
                }
            }

            Text {
                id: txtMessage
                anchors.top: usersContainer.bottom;
                anchors.margins: 20
                anchors.horizontalCenter: parent.horizontalCenter
                color: "white"
                text: textConstants.promptSelectUser
                wrapMode: Text.WordWrap
                width:parent.width - 60
                font.pixelSize: 20
            }

            Text {
                id: errMessage
                anchors.top: txtMessage.bottom
                anchors.margins: 20
                anchors.horizontalCenter: parent.horizontalCenter
                color: "red"
                text: "The current theme cannot be loaded due to the errors below, please select another theme.\n" + __sddm_errors
                wrapMode: Text.WordWrap
                width: parent.width - 60
                font.pixelSize: 20
                visible: __sddm_errors !== ""
            }
        }
    }

    Rectangle {
        id: actionBar
        anchors.top: parent.top;
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width; height: 40
        //visible: primaryScreen

        Row {
            anchors.left: parent.left
            anchors.margins: 5
            height: parent.height
            spacing: 5

            Text {
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter

                text: textConstants.session
                font.pixelSize: 16
                verticalAlignment: Text.AlignVCenter
            }

            ComboBox {
                id: session
                width: 245
                anchors.verticalCenter: parent.verticalCenter

                arrowIcon: "qrc:///theme/angle-down.png"

                model: sessionModel
                index: sessionModel.lastIndex

                font.pixelSize: 14

                // KeyNavigation.backtab: nextUser; KeyNavigation.tab: layoutBox
            }

            Text {
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter

                visible: layoutBox.visible

                text: textConstants.layout
                font.pixelSize: 16
                verticalAlignment: Text.AlignVCenter
            }

            LayoutBox {
                id: layoutBox
                width: 90
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 14

                visible: keyboard.enabled && keyboard.layouts.length > 0

                arrowIcon: "qrc:///theme/angle-down.png"

                KeyNavigation.backtab: session; KeyNavigation.tab: btnShutdown
            }
        }

        Row {
            height: parent.height
            anchors.right: parent.right
            anchors.margins: 5
            spacing: 5

            ImageButton {
                id: btnReboot
                height: parent.height
                source: "qrc:///theme/reboot.png"

                visible: sddm.canReboot

                onClicked: sddm.reboot()

                KeyNavigation.backtab: layoutBox; KeyNavigation.tab: btnShutdown
            }

            ImageButton {
                id: btnShutdown
                height: parent.height
                source: "qrc:///theme/shutdown.png"

                visible: sddm.canPowerOff

                onClicked: sddm.powerOff()

                KeyNavigation.backtab: btnReboot; KeyNavigation.tab: prevUser
            }
        }
    }
}
