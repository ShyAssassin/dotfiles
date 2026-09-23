pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Widgets
import Quickshell.Services.SystemTray

Item {
    id: appTrayRoot
    implicitWidth: appTrayRow.implicitWidth
    implicitHeight: appTrayRow.implicitHeight

    RowLayout {
        spacing: 2.35
        id: appTrayRow

        Repeater {
            model: SystemTray.items
            delegate: Rectangle {
                id: appTrayItem
                required property SystemTrayItem modelData

                width: appTrayItemIcon.implicitWidth
                height: appTrayItemIcon.implicitHeight
                visible: !(modelData.status === Status.Passive)

                color: appTrayItemMouseArea.containsMouse ? '#09ffffff' : "transparent"

                IconImage {
                    implicitSize: 25
                    id: appTrayItemIcon
                    anchors.centerIn: parent
                    source: appTrayItem.modelData.icon
                }

                MouseArea {
                    hoverEnabled: true
                    anchors.fill: parent
                    id: appTrayItemMouseArea
                    cursorShape: Qt.ArrowCursor
                    implicitWidth: appTrayItem.width
                    implicitHeight: appTrayItem.height
                    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

                    ToolTip {
                        delay: 725
                        timeout: 3725
                        id: appTrayItemToolTip
                        parent: appTrayItemMouseArea
                        x: appTrayItemIcon.width - appTrayItemToolTip.width - 25
                        visible: appTrayItemMouseArea.containsMouse && text.length > 0
                        text: appTrayItem.modelData.tooltipTitle || appTrayItem.modelData.title

                        background: Rectangle {
                            radius: 8
                            border.width: 1
                            color: "#211e2e"
                            border.color: "#313244"
                        }

                        contentItem: Text {
                            color: "#ece9e9"
                            font.pixelSize: 13
                            font.family: "Sans"
                            text: appTrayItemToolTip.text
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }

                    onClicked: mouse => {
                        const item = appTrayItem.modelData;

                        if (mouse.button === Qt.LeftButton) {
                            item.activate();
                        } else if (mouse.button === Qt.MiddleButton) {
                            item.secondaryActivate();
                        } else if (mouse.button === Qt.RightButton) {
                            if (item.hasMenu) {
                                appTrayItemContextMenu.visible = !appTrayItemContextMenu.visible;
                            }
                        }
                    }
                }

                PopupWindow {
                    visible: false
                    grabFocus: true
                    color: "transparent"
                    id: appTrayItemContextMenu

                    anchor.item: appTrayItemMouseArea
                    anchor.gravity: Edges.Bottom | Edges.Left
                    anchor.rect.x: appTrayItemMouseArea.width / 2
                    anchor.rect.y: appTrayItemMouseArea.height / 2

                    implicitHeight: appTrayItemContextMenuColumn.implicitHeight + 8
                    implicitWidth: Math.max(160, appTrayItemContextMenuColumn.implicitWidth)

                    QsMenuOpener {
                        id: appTrayItemContextMenuOpener
                        menu: appTrayItem.modelData.menu
                    }

                    Rectangle {
                        radius: 8
                        border.width: 1
                        color: "#211e2e"
                        anchors.fill: parent
                        border.color: "#313244"
                        id: appTrayItemContextMenuBackground

                        ColumnLayout {
                            spacing: 0
                            anchors.margins: 4
                            anchors.fill: parent
                            id: appTrayItemContextMenuColumn

                            Repeater {
                                model: appTrayItemContextMenuOpener.children
                                delegate: Item {
                                    id: appTrayItemContextMenuEntry
                                    required property QsMenuEntry modelData

                                    Layout.fillWidth: true
                                    implicitWidth: appTrayItemContextMenuEntryLabel.implicitWidth + 16
                                    implicitHeight: appTrayItemContextMenuEntry.modelData.isSeparator ? 9 : 28

                                    Rectangle {
                                        height: 1
                                        color: "#3a3f4b"
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        anchors.verticalCenter: parent.verticalCenter
                                        visible: appTrayItemContextMenuEntry.modelData.isSeparator
                                    }

                                    Rectangle {
                                        radius: 4
                                        anchors.fill: parent
                                        visible: !appTrayItemContextMenuEntry.modelData.isSeparator
                                        color: appTrayItemContextMenuEntryMouseArea.containsMouse ? "#313244" : "transparent"

                                        Text {
                                            id: appTrayItemContextMenuEntryLabel
                                            font.pixelSize: 13
                                            font.family: "Sans"
                                            anchors.leftMargin: 8
                                            anchors.left: parent.left
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: appTrayItemContextMenuEntry.modelData.text
                                            color: appTrayItemContextMenuEntry.modelData.enabled ? "#ece9e9" : "#6c7086"
                                        }

                                        MouseArea {
                                            hoverEnabled: true
                                            anchors.fill: parent
                                            id: appTrayItemContextMenuEntryMouseArea
                                            enabled: appTrayItemContextMenuEntry.modelData.enabled

                                            onClicked: {
                                                appTrayItemContextMenu.visible = false;
                                                appTrayItemContextMenuEntry.modelData.triggered();
                                            }
                                        }
                                    } // Rectangle
                                } // CMDelegate
                            } // CMRepeater
                        } // ColumnLayout
                    } // Rectangle
                } // PopupWindow
            } // TIDelgate
        } // Repeater
    } // RowLayout
} // Item
