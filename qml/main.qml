import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    visible: true
    width: 400
    height: 300
    title: "SIMPyLink"

    menuBar: Loader {
        source: "page/topMenu.qml"
    }

    Loader {
        id: popupLoader
    }

    Item {
        id: blockContainer
        anchors.fill: parent

        signal startConnection(int x, int y)
        signal endConnection(int x, int y)

        property var connections: []  // Liste des connexions

        onStartConnection: {
            console.log("Start connection at:", x, y);
            // Stocker le point de départ temporaire
            blockContainer.tempConnection = { startX: x, startY: y, endX: null, endY: null };
        }

        onEndConnection: {
            console.log("End connection at:", x, y);
            // Compléter la connexion et l'ajouter à la liste
            if (blockContainer.tempConnection) {
                blockContainer.tempConnection.endX = x;
                blockContainer.tempConnection.endY = y;
                blockContainer.connections.push(blockContainer.tempConnection);
                blockContainer.tempConnection = null;
                connectionCanvas.requestPaint();  // Redessiner les connexions
            }
        }

        property var tempConnection: null  // Connexion temporaire en cours


        Repeater {
            model: simpleElements

            Loader {
                source: "elements/simpleBlockElement.qml"
                onLoaded: {
                    item.elementModel = modelData
                    item.x = index * 120 
                    item.y = 100
                }
            }
        }

        // Dessiner les connexions
        Canvas {
            id: connectionCanvas
            anchors.fill: parent

            onPaint: {
                var ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);

                // Dessiner toutes les connexions
                for (var i = 0; i < blockContainer.connections.length; i++) {
                    var connection = blockContainer.connections[i];
                    ctx.beginPath();
                    ctx.moveTo(connection.startX, connection.startY);
                    ctx.lineTo(connection.endX, connection.endY);
                    ctx.strokeStyle = "black";
                    ctx.lineWidth = 2;
                    ctx.stroke();
                }
            }
        }
    }
}   
