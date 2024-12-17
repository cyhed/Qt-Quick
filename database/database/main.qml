import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import QtQuick.Dialogs
import QtQuick.Controls.Material 2.15

ApplicationWindow {
    id: appWin
    visible: true
    width: 360
    height: 520

    Material.theme: Material.Dark
    Material.primary: "#006400"
    Material.accent: "#006400"

    property int previousElement
    property string currentIcon: "qrc:/icons/add_call"
    property string addIcon: "qrc:/icons/person_add"
    property bool addButtonStatus: false
    property string fnames
    property string snames
    property string mnames
    property string heights
    property string weights

    header: ToolBar {
        id: toolBar
        Material.background: "#006400"

        ToolButton {
            id: menuButton
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            icon.source: currentIcon
            onClicked: {
                if (stackView.depth === 1) {
                    previousElement = 1
                    currentIcon = "qrc:/icons/first_page"
                    addButtonStatus = true
                    stackView.push(addPage)
                } else if (stackView.depth === 2 && previousElement === 1) {
                    currentIcon = "qrc:/icons/add_call"
                    addButtonStatus = false
                    stackView.pop()
                }
            }
        }

        Label {
            anchors.centerIn: parent
            text: "Contacts"
            font.bold: true
        }

        ToolButton {
            id: buttonAdd
            resources: addPage
            visible: /*addButtonStatus*/ false
            anchors.right: parent.right
            icon.source: "qrc:/icons/person_add"
            onClicked: {
                database.insertIntoTable(fnames, snames, mnames, weights);
                myModel.updateModel();

                fnameField.clear();
                snameField.clear();
                mnameField.clear();                
                weightField.clear();
            }
        }
    }

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: listPage
    }

    Component {
        id: listPage
        Item {
            width: appWin.width
            height: appWin.height
            Rectangle {
                anchors.fill: parent
                color: "#121212"

                ListView {
                    id: listView
                    anchors.fill: parent
                    model: myModel
                    delegate: Item {
                        id: item
                        property int itemIndex: index
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: 70

                        RoundButton {
                            anchors.fill: parent
                            text: FirstName + " " + SurName + " " + MidleName + "\n" + PostIndex
                            background: Rectangle {
                                color: "#1E1E1E"
                                radius: 50
                            }
                            Material.foreground: "#006400"
                            onClicked: {
                                database.removeRecord(myModel.getId(itemIndex))
                                myModel.updateModel();
                            }
                        }
                    }
                }
            }
        }
    }

    Component {
        id: addPage
        Item {
            Rectangle {
                anchors.fill: parent
                color: "#121212"

                ColumnLayout {
                    id: columnLayout
                    y: toolBar.height
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 70
                    spacing: 20

                    TextField {
                        id: fnameField
                        Material.foreground: "white"
                        Material.background: "#1E1E1E"
                        placeholderText: "Enter First Name"
                        Layout.fillWidth: true

                        onTextChanged: {
                            if(text.length > 20){
                                text = text.substring(0,20);
                            }
                            text = text.replace(/[^a-zA-Zа-яА-ЯёЁ]/g, "");
                            fnames = text;
                        }
                    }
                    TextField {
                        id: snameField
                        Material.foreground: "white"
                        Material.background: "#1E1E1E"
                        placeholderText: "Enter Surname"
                        Layout.fillWidth: true
                        onTextChanged: {
                            if(text.length > 20){
                                text = text.substring(0,20);
                            }
                            text = text.replace(/[^a-zA-Zа-яА-ЯёЁ]/g, "");
                            snames = text;
                        }
                    }
                    TextField {
                        id: mnameField
                        Material.foreground: "white"
                        Material.background: "#1E1E1E"
                        placeholderText: "Enter Middle Name"
                        Layout.fillWidth: true
                        onTextChanged: {
                            if(text.length > 20){
                                text = text.substring(0,20);
                            }
                            text = text.replace(/[^a-zA-Zа-яА-ЯёЁ]/g, "");
                            mnames = text;
                        }
                    }
                    TextField {
                        id: postIndexField
                        Material.foreground: "white"
                        Material.background: "#1E1E1E"
                        placeholderText: "Enter Post Index"
                        Layout.fillWidth: true
                        onTextChanged: {
                            if(text.length > 9){
                                text = text.substring(0,9);
                            }
                            text = text.replace(/[^0-9a-z]/g, "");
                            heights = text;
                        }
                    }


                    Button {
                        id: insertBtn
                        text: "Push"
                        Layout.fillWidth: true
                        Material.background: "#006400"
                        onClicked: {
                            database.insertIntoTable(fnameField.text, snameField.text, mnameField.text, postIndexField.text);
                            myModel.updateModel();

                            fnameField.clear();
                            snameField.clear();
                            mnameField.clear();
                            postIndexField.clear();

                        }
                    }
                }
            }
        }
    }
}
