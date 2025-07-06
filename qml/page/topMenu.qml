import QtQuick 2.15
import QtQuick.Controls 2.15

MenuBar {
    Menu {
        title: "File"
        MenuItem {
            text: "New Project"
            onTriggered: console.log("New clicked")
        }
        MenuItem {
            text: "Open"
            onTriggered: console.log("Open clicked")
        }
        MenuItem {
            text: "Save"
            onTriggered: console.log("Save clicked")
        }
        MenuSeparator {}
        MenuItem {
            text: "Exit"
            onTriggered: Qt.quit()
        }
    }

    Menu {
        title: "Edit"
        MenuItem {
            text: "Undo"
            onTriggered: console.log("Undo clicked")
        }
        MenuItem {
            text: "Redo"
            onTriggered: console.log("Redo clicked")
        }
        MenuItem {
            text: "Add New Block"
            onTriggered: {
                if (!popupLoader.item) {
                    popupLoader.source = "page/blockSelector.qml"
                    popupLoader.active = true
                    popupLoader.item.open()  // montre le popup
                } else {
                    popupLoader.item.open()
                }
            }
        }
    }

    Menu {
        title: "Help"
        MenuItem {
            text: "About"
            onTriggered: console.log("About clicked")
        }
    }
}
