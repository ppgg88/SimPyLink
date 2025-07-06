// qml/page/blockSelector.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Popup {
    id: popup
    width: 300
    height: 250
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    property point dragStartPos

    background: Rectangle {
        color: "#f0f0f0"
        border.color: "gray"
        radius: 10
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 0
        spacing: 0

        // 🔸 Header déplacable
        Rectangle {
            height: 30
            color: "#d0d0d0"
            Layout.fillWidth: true

            Text {
                anchors.centerIn: parent
                text: "Select a block"
                font.bold: true
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.OpenHandCursor
                onPressed: (mouse) => {
                    dragStartPos = Qt.point(mouse.x, mouse.y)
                }

                onPositionChanged: (mouse) => {
                    popup.x += mouse.x - dragStartPos.x
                    popup.y += mouse.y - dragStartPos.y
                }
            }
        }

        // 🔸 Body
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10

            ListView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                model: ["Block A", "Block B", "Block C"]
                delegate: ItemDelegate {
                    text: modelData
                    onClicked: {
                        console.log("Selected:", modelData)
                        popup.close()
                    }
                }
            }

            Button {
                text: "Cancel"
                Layout.alignment: Qt.AlignRight
                onClicked: popup.close()
            }
        }
    }
}
