import QtQuick 2.0
import SddmComponents 2.0

Column {
    property real gScale: 1

    spacing: config.spacing
    anchors.margins: config.spacing

    Rectangle {
       Clock {
           id: clock
           anchors.centerIn: parent
           color: "white"
           timeFont {
                family: config.font_family
                pixelSize: config.clockFontSize * gScale
                bold: true
           }
           dateFont {
                family: config.font_family
                pixelSize: config.dateFontSize * gScale
                bold: false
           }
       }
    }
}
