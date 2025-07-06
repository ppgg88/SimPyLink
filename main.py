from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine, qmlRegisterType
from pathlib import Path
import sys

from widgets.simpleBlockElement import SimpleBlockElement
from app.blockLogic import BlockLogic

QML_FOLDER = Path(__file__).resolve().parent / "qml"

if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    logic = BlockLogic()

    engine.rootContext().setContextProperty("simpleElements", logic.toList())

    # Charger le fichier QML principal
    qml_file = QML_FOLDER / "main.qml"
    engine.load(qml_file)

    if not engine.rootObjects():
        print("Failed to load QML file:", qml_file)
        sys.exit(-1)

    sys.exit(app.exec())