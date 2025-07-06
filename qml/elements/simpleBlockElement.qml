import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: simpleBlockElement

    property var elementModel
    property var connections: []
    property string blockId: elementModel.blockId

    onElementModelChanged: {
        if (elementModel) {
            console.log("elementModel is defined:", elementModel);
            blockId = elementModel.blockId;  // Mettre à jour blockId

            // Appeler une méthode de elementModel si nécessaire
            if (typeof elementModel.onDrag === "function") {
                elementModel.onDrag(item.x + draggable.x, item.y + draggable.y);
                elementModel.onWidthChanged(draggable.implicitWidth);
                elementModel.onHeightChanged(draggable.implicitHeight);
                console.log("Block", elementModel.blockId, "dragged to position (", draggable.parent.x + draggable.x, ",", draggable.parent.y + draggable.y, ")");
            }
        }
    }

    Rectangle {
        id: draggable
        implicitWidth: textElement.width + 20
        implicitHeight:  Math.max(elementModel.inputSize, elementModel.outputSize) * 50
        color: elementModel.color

        Text {
            id: textElement
            anchors.centerIn: parent
            text: qsTr(elementModel.text)
            color: "white"
        }

        // Input
        Repeater {
            model: elementModel.inputSize
            Rectangle {
                width: 10
                height: 10
                color: "black"
                anchors.right: parent.left
                y: index * 50 + 20 + (Math.max(elementModel.inputSize, elementModel.outputSize)-elementModel.inputSize)*25

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log("Input clicked at index:", index);
                        //blockContainer.startConnection(draggable.parent.x+parent.x+draggable.x+5, draggable.parent.y+parent.y+draggable.y+5);
                        blockContainer.startConnection(elementModel, index)
                    }
                }
            }
        }

        // Output
        Repeater {
            model: elementModel.outputSize
            Rectangle {
                width: 10
                height: 10
                color: "black"
                anchors.left: parent.right
                y: index * 50 + 20 + (Math.max(elementModel.inputSize, elementModel.outputSize)-elementModel.outputSize)*25
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log("Output clicked at index:", index);
                        // Déclencher un signal pour terminer une connexion
                        //blockContainer.endConnection(draggable.parent.x+parent.x+draggable.x+5, draggable.parent.y+parent.y+draggable.y+5, elementModel.blockId, index);
                        blockContainer.endConnection(elementModel, index)
                    }
                }
            }
        }

        MouseArea {
            id: dragArea
            anchors.fill: parent
            drag.target: draggable
            onReleased: {
                if (elementModel && elementModel.onDrag) {
                    elementModel.onDrag(draggable.parent.x+draggable.x, draggable.parent.y+draggable.y);
                    connectionCanvas.requestPaint();
                }
            }
        }

    }
}
