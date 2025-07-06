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

        signal startConnection(var modelSource, int index);
        signal endConnection(var modelOutput, int index);

        property var connections: []  // Liste des connexions

        function handleEndConnection(modelOutput, index) {
            if (blockContainer.tempConnection) {
                blockContainer.tempConnection.output = modelOutput;
                blockContainer.tempConnection.indexOutput = index;
                blockContainer.connections.push(blockContainer.tempConnection);
                blockContainer.tempConnection = null;
                connectionCanvas.requestPaint();  // Redessiner les connexions
            }
        }


        function handleStartConnection(modelSource, index) {
            blockContainer.tempConnection = {
                source: modelSource,
                indexSource: index,
                output: null,
                indexOutput: null,
            };
        }

        onStartConnection: blockContainer.handleStartConnection(arguments[0], arguments[1])
        onEndConnection: blockContainer.handleEndConnection(arguments[0], arguments[1])

        property var tempConnection: null  // Connexion temporaire en cours


        Repeater {
            model: simpleElements

            Loader {
                source: "elements/simpleBlockElement.qml"
                onLoaded: {
                    item.x = index * 120
                    item.y = 100 
                    item.elementModel = modelData 
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
                    ctx.moveTo(connection.source.x - 5, connection.source.y + connection.indexSource * 50 + 20 + (Math.max(connection.source.inputSize, connection.source.outputSize)-connection.source.inputSize)*25 + 5);
                    ctx.lineTo(connection.output.x + connection.output.width - 25,  connection.output.y + connection.indexOutput * 50 + 20 + (Math.max(connection.output.inputSize, connection.output.outputSize)-connection.output.outputSize)*25 + 5);
                    ctx.strokeStyle = "black";
                    ctx.lineWidth = 2;
                    ctx.stroke();
                }
            }
        }
    }
}   
