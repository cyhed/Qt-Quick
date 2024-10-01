import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls
ApplicationWindow {
    id: window
    width: 640
    height: 480
    visible: true
    title: qsTr("помс лабораторная работа 2")

    header:
        ToolBar{
           ToolButton {
               id: menuBzutton
               anchors.left: parent.left
               anchors.verticalCenter: parent.verticalCenter
               icon.source: "qrc:/icon/icon/menu_24dp_E8EAED.svg"
               onClicked: drawer.open()

               Material.background: Material.Orange
           }
           Label{
               anchors.centerIn: parent
               text: "программа"
           }
    }

    Drawer{
        id: drawer
        width: Math.min(window.width, window.height) / 3* 2
        height: window.height
        Column{
            anchors.fill: parent
            ItemDelegate{
                text: qsTr("О программе")
                width: parent.width
                onClicked: {
                    drawer.close()
                    aboutDialog.open()
                }
            }
            ItemDelegate {
                text: qsTr("Выход")
                width: parent.width
                onClicked: {
                    drawer.close()
                    exitDialog.open()
                }
            }
        }
    }
    Dialog {
        id: aboutDialog
        title: qsTr("О программе")
        Label {
            anchors.fill: parent
            text: qsTr("Это справка о программе")
            horizontalAlignment: Text.AlignHCenter
        }
    }
    Dialog {
        id: exitDialog
        title: qsTr("Выход")
        Label {
            anchors.fill: parent
            text: qsTr("Вы хотете выйти?")
            horizontalAlignment: Text.AlignHCenter
        }
    standardButtons:  Dialog.No | Dialog.Yes
    onAccepted:   Qt.quit()
    }


        Rectangle{

            anchors.horizontalCenter: elInput.horizontalCenter
            anchors.margins: 20
            anchors.bottom: elInput.top
            width: 150; height: 50
            Label {

                id: outputEl
                 anchors.horizontalCenter: parent.horizontalCenter
                 color: "slategrey"
                text: " "
            }
        }
        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter:  parent.verticalCenter
            id: elInput
            width: 150; height: 50
            color: "linen"
            Row {

                TextInput {
                    id: input1
                    x: 8; y: 8
                    width: 150; height: 20
                    focus: true
                    text: "Введите ФИО"
                }
                ToolButton {
                    id: clearButton



                    anchors.margins: 8

                    icon.source: "qrc:/icon/icon/menu_24dp_E8EAED.svg"

                    onClicked:{
                               outputEl.text =   ""
                                input1.text = "Введите ФИО"
                    }
                    Material.background: Material.Orange
                }
            }
        }
        Rectangle {
            width: 200; height: 100
            anchors.margins: 20
            anchors.top: elInput.bottom
            anchors.horizontalCenter: elInput.horizontalCenter
            border.color: "lightsteelblue"
            color: "slategrey"
            border.width: 4
            radius: 8
            ToolButton {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                id: checkBzutton
                anchors.fill: parent
                anchors.margins: 8

                text: qsTr("Проверить")

                onClicked: {
                    if(input1.text === "Золотов В.В."){
                        outputEl.text =   "Верно"
                    }
                    else{
                        outputEl.text =   "Не верно"
                    }
                }

                Material.background: Material.Orange
            }
        }

}


