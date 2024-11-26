import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtLocation 5.15
import QtPositioning 5.15


ApplicationWindow {
    // …
    id: appWin
    visible: true
    width: 360
    height: 520
    title: ""
    Material.accent: Material.LightBlue
    property int previousElement
    property string currentIcon: "qrc:/icon/list"
    property string tileSources
    property string markerCoordinates: "No marker set"

    header: ToolBar {
        id: toolBar
        Material.background: "#07575b"

        ToolButton {
            id: menuButton
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            icon.source: currentIcon
            onClicked: {
                if (stackView.depth === 1) {
                    previousElement = 1
                    stackView.push(page2)
                    currentIcon = "qrc:/icon/planet"
                } else if (stackView.depth === 2 && previousElement === 1) {
                    currentIcon = "qrc:/icon/list"
                    stackView.pop()
                }
            }
        }

        Label {
            anchors.centerIn: parent
            text: "Карта"
            font.bold: true
        }
    }

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: page1
    }
    ListModel {
        id: coordinatesModel
    }


    function toDMS(coordinate) {
        var degrees = Math.floor(coordinate);
        var minutes = Math.floor((coordinate - degrees) * 60);
        var seconds = (((coordinate - degrees) * 60) - minutes) * 60;

        return degrees + "° " + minutes + "' " + seconds.toFixed(1) + "\"";
    }


    Component {
        id: page1
        Item {
            Plugin {
                id: mapPlugin
                name: "osm"
            }

            Map {
                id: map
                anchors.fill: parent
                plugin: mapPlugin
                center: QtPositioning.coordinate(52.09675308716692, 23.758191882161242)
                zoomLevel: 14
                property geoCoordinate startCentroid
                property var marker

                Component {
                    id: markerComponent
                    MapQuickItem {
                        coordinate: QtPositioning.coordinate(0, 0)
                        anchorPoint.x: 0.5
                        anchorPoint.y: 1.0

                        sourceItem: Image {
                            source: "qrc:/icon/pin"
                            width: 40
                            height: 40
                            anchors.centerIn: parent

                        }
                    }
                }


                PinchHandler {
                    id: pinch
                    target: null
                    onActiveChanged: if (active) {
                                         map.startCentroid = map.toCoordinate(pinch.centroid.position, false)
                                     }
                    onScaleChanged: (delta) => {
                                        map.zoomLevel += Math.log2(delta)
                                        map.alignCoordinateToPoint(map.startCentroid, pinch.centroid.position)
                                    }
                    onRotationChanged: (delta) => {
                                           map.bearing -= delta
                                           map.alignCoordinateToPoint(map.startCentroid, pinch.centroid.position)
                                       }
                    grabPermissions: PointerHandler.TakeOverForbidden
                }

                WheelHandler {
                    id: wheel
                    acceptedDevices: Qt.platform.pluginName === "cocoa" || Qt.platform.pluginName === "wayland"
                                     ? PointerDevice.Mouse | PointerDevice.TouchPad
                                     : PointerDevice.Mouse
                    rotationScale: 1/120
                    property: "zoomLevel"
                }

                DragHandler {
                    id: drag
                    target: null
                    onTranslationChanged: (delta) => map.pan(-delta.x, -delta.y)
                }

                Shortcut {
                    enabled: map.zoomLevel < map.maximumZoomLevel
                    sequence: StandardKey.ZoomIn
                    onActivated: map.zoomLevel = Math.round(map.zoomLevel + 1)
                }

                Shortcut {
                    enabled: map.zoomLevel > map.minimumZoomLevel
                    sequence: StandardKey.ZoomOut
                    onActivated: map.zoomLevel = Math.round(map.zoomLevel - 1)
                }


                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        var coordinate = map.toCoordinate(Qt.point(mouse.x, mouse.y))
                        if (map.marker) {
                            map.marker = markerComponent.createObject(map)
                            map.marker.coordinate = coordinate
                            map.addMapItem(map.marker)
                        } else {
                            map.marker = markerComponent.createObject(map)
                            map.marker.coordinate = coordinate
                            map.addMapItem(map.marker)
                        }
                        //console.log( "Marker coordinates: " + coordinate.latitude + ", " + coordinate.longitude)
                        /*coordinatesModel.append({
                                                    "latitude": coordinate.latitude,
                                                    "longitude": coordinate.longitude
                                                })*/
                        saveMesg.visible = false

                    }
                    onPressAndHold: {
                        var coordinate = map.toCoordinate(Qt.point(mouse.x, mouse.y))
                        if (map.marker) {
                            map.marker = markerComponent.createObject(map)
                            map.marker.coordinate = coordinate
                            map.addMapItem(map.marker)
                        } else {
                            map.marker = markerComponent.createObject(map)
                            map.marker.coordinate = coordinate
                            map.addMapItem(map.marker)
                        }
                        console.log( "Position coordinates: " + coordinate.latitude + ", " + coordinate.longitude)
                        coordinatesModel.append({
                                                    "latitude": coordinate.latitude,
                                                    "longitude": coordinate.longitude
                                                })
                        saveMesg.visible = true

                    }

                    Text {
                        id: saveMesg
                    // ...
                        visible: false
                        font.pointSize: 15
                        text: "Save"

                        anchors.horizontalCenter:  parent.horizontalCenter
                        color: "#66a5ad"
                    }
                }
            }
        }
    }

    Component {
        id: page2
        Item {
            width: appWin.width
            height: appWin.height

            Rectangle {
                color: "#c4dfe6"
                anchors.fill: parent
                ListView {
                    anchors.fill: parent
                    model: coordinatesModel
                    delegate: Item {
                        width: parent.width
                        height: 40


                        Text {
                            anchors.leftMargin: 20
                            text: "[Position " + (index + 1) + "] : " + toDMS(model.latitude) + " N, " + toDMS(model.longitude) + " E, "
                            anchors.verticalCenter: parent.verticalCenter
                            font.pointSize: 11
                            color: "#003b46"
                        }
                    }
                }
            }
        }
    }
}


