import QtQuick 2.12
import QtQuick.Window 2.12

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    Text {
        id: mainText
        text: qsTr("Hello World")

        font.family: "Liberation Serif"
        font.bold: true
        font.pointSize: 14
        style: Text.Sunken


        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter:  parent.verticalCenter

    }
    Rectangle {
        id: rect2

        width: 200; height: 100
        border.color: "lightsteelblue"
        color: "slategrey"
        border.width: 4
        radius: 8

        anchors.top: mainText.bottom
        anchors.horizontalCenter: mainText.horizontalCenter
        MouseArea {
            id: area
            width: parent.width
            height: parent.height
            onClicked: Qt.quit()
        }



        Text {
            id: rectangleText
            text: qsTr("Exit")
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter:  parent.verticalCenter

            font.family: "Liberation Serif"
            font.bold: true
            font.pointSize: 14
            style: Text.Sunken

        }
    }


}
