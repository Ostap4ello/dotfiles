/***************************************************************************
* Copyright (c) 2015 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
* Copyright (c) 2013 Abdurrahman AVCI <abdurrahmanavci@gmail.com
*
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without restriction,
* including without limitation the rights to use, copy, modify, merge,
* publish, distribute, sublicense, and/or sell copies of the Software,
* and to permit persons to whom the Software is furnished to do so,
* subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included
* in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
* OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
* OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
* ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
* OR OTHER DEALINGS IN THE SOFTWARE.
*
***************************************************************************/

import QtQuick 2.0
import SddmComponents 2.0
import QtQuick.Window 2.15
import "Components"

Rectangle {
    id: container

    property real globalScale: config.scale * Screen.width / 1600.0
    //LayoutMirroring.enabled: Qt.locale().textDirection == Qt.RightToLeft
    //LayoutMirroring.childrenInherit: true
    //TextConstants { id: textConstants }

    width: Screen.width
    height: Screen.height
    color: config.backgroundColor

    Image {
        visible: config.backgroundImageEnable == true ? true : false 
        anchors {
            fill: parent
        }

        source: "../background.jpg"
        fillMode: Image.PreserveAspectCrop

        MouseArea {
            anchors.fill: parent
            onClicked: {
                userField.focus = true
            }
        }
    }

    DateTimePanel {
        anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
            horizontalCenterOffset: -0.15 * Screen.width
        }

        gScale: globalScale
    }

    LoginPanel {
        id: loginPanel
        anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
            horizontalCenterOffset: 0.15 * Screen.width
        }

        sessionIndex: pmp.sessionIndex
        gScale: globalScale

    }

    InfoPanel {
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
        }

        gScale: globalScale
    }

    PowerModesPanel {
        id: pmp
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
        }

        //sessionIndex: sessionModel.lastIndex
        gScale: globalScale


    }
}
