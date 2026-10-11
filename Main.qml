import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: window

    color: "transparent"
    flags: Qt.Window | Qt.FramelessWindowHint
    height: 650
    visible: true
    width: 1000

    // Фон окна со скруглёнными углами
    Rectangle {
        anchors.fill: parent
        color: "#18191D"
        radius: 12
    }

    // Верхняя панель окна
    Rectangle {
        id: titleBar

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        color: "transparent"
        height: 44

        Text {
            anchors.centerIn: parent
            color: "#AEB6C4"
            font.family: "Consolas"
            font.bold: true
            font.pixelSize: 15
            text: "freedMe"
        }

        MouseArea {
            anchors.left: parent.left
            anchors.right: buttons.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            onPressed: window.startSystemMove()
            onDoubleClicked: {
                if (window.visibility === Window.Maximized)
                    window.showNormal()
                else
                    window.showMaximized()
            }
        }

        Row {
            id: buttons

            anchors.right: parent.right
            height: 36
            spacing: 0

            // Свернуть
            Item {
                width: 46
                height: 36

                Rectangle {
                    width: 12
                    height: 1.5
                    color: wrapArea.containsMouse ? "#FFFFFF" : "#AEB6C4"
                    anchors.centerIn: parent
                }

                MouseArea {
                    id: wrapArea
                    anchors.fill: parent
                    hoverEnabled: true

                    onEntered: hoverBackground.color = "#292C34"
                    onExited: hoverBackground.color = "transparent"
                    onClicked: window.showMinimized()
                }

                Rectangle {
                    id: hoverBackground
                    anchors.fill: parent
                    color: "transparent"
                    z: -1
                }
            }

            // Развернуть / восстановить
            Item {
                width: 46
                height: 36

                Rectangle {
                    anchors.fill: parent
                    color: unwrapArea.containsMouse ? "#292C34" : "transparent"
                }

                Rectangle {
                    width: 10
                    height: 10
                    anchors.centerIn: parent
                    color: "transparent"
                    border.width: 1
                    border.color: unwrapArea.containsMouse ? "#FFFFFF" : "#AEB6C4"
                }

                MouseArea {
                    id: unwrapArea
                    anchors.fill: parent
                    hoverEnabled: true

                    onClicked: {
                        if (window.visibility === Window.Maximized)
                            window.showNormal()
                        else
                            window.showMaximized()
                    }
                }
            }

            // Закрыть
            Item {
                width: 46
                height: 36

                Rectangle {
                    anchors.fill: parent
                    color: closeArea.containsMouse ? "#E81123" : "transparent"
                }

                Rectangle {
                    width: 15
                    height: 1.5
                    color: closeArea.containsMouse ? "white" : "#AEB6C4"
                    rotation: 45
                    anchors.centerIn: parent
                }

                Rectangle {
                    width: 15
                    height: 1.5
                    color: closeArea.containsMouse ? "white" : "#AEB6C4"
                    rotation: -45
                    anchors.centerIn: parent
                }

                MouseArea {
                    id: closeArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: window.close()
                }
            }
        }
    }
}