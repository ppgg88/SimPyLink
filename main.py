from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine, qmlRegisterType
from pathlib import Path
import sys

from widgets.simpleBlockElement import SimpleBlockElement

QML_FOLDER = Path(__file__).resolve().parent / "qml"

if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    elements = [
        SimpleBlockElement("Block 1", "blue"),
        SimpleBlockElement("Block 2", "green", 1, 2),
        SimpleBlockElement("Block 3", "red", 3, 1)
    ]

    engine.rootContext().setContextProperty("simpleElements", elements)

    # Charger le fichier QML principal
    qml_file = QML_FOLDER / "main.qml"
    engine.load(qml_file)

    if not engine.rootObjects():
        print("Failed to load QML file:", qml_file)
        sys.exit(-1)

    sys.exit(app.exec())