from PySide6.QtCore import QObject, Property, Signal, Slot

class SimpleBlockElement(QObject):
    """
    SimpleBlockElement is a QObject that represents a simple block element in QML.
    It has properties for the text and color of the block, and signals for when
    the text or color changes.
    """

    textChanged = Signal()
    colorChanged = Signal()
    inputSizeChanged = Signal()
    outputSizeChanged = Signal()
    onDrag = Signal(float, float)

    lastBlockId = 0

    def __init__(self, text="Default Text", color="blue", inputSize=1, outputSize=1, parent=None):
        super().__init__(parent)
        self._text = text
        self._color = color
        self._inputSize = inputSize
        self._outputSize = outputSize
        SimpleBlockElement.lastBlockId += 1
        self._blockId = SimpleBlockElement.lastBlockId

        connectedBlocksInput = [None] * inputSize
        connectedBlocksOutput = [None] * outputSize

    @Property(str, notify=textChanged)
    def text(self):
        return self._text
    @text.setter
    def text(self, value):
        if self._text != value:
            self._text = value
            self.textChanged.emit()

    @Property(str, notify=colorChanged)
    def color(self):
        return self._color
    @color.setter
    def color(self, value):
        if self._color != value:
            self._color = value
            self.colorChanged.emit()

    @Property(int, notify=inputSizeChanged)
    def inputSize(self):
        return self._inputSize
    @inputSize.setter
    def inputSize(self, value):
        if value < 0:
            raise ValueError("Input size cannot be negative.")
        if self.imputSize > value:
            connectedBlocksInput = connectedBlocksInput[:value]
        elif self.inputSize < value:
            connectedBlocksInput.extend([None] * (value - self._inputSize))
        if self._inputSize != value:
            self._inputSize = value
            self.inputSizeChanged.emit()

    @Property(int, notify=outputSizeChanged)
    def outputSize(self):
        return self._outputSize
    @outputSize.setter
    def outputSize(self, value):
        if value < 0:
            raise ValueError("Output size cannot be negative.")
        if self.outputSize > value:
            connectedBlocksOutput = connectedBlocksOutput[:value]
        elif self.outputSize < value:
            connectedBlocksOutput.extend([None] * (value - self._outputSize))
        if self._outputSize != value:
            self._outputSize = value
            self.outputSizeChanged.emit()

    @Property(int, constant=True)
    def blockId(self):
        return self._blockId
    
    @Slot(float, float)
    def onDrag(self, x, y):
        print(f"Block {self._blockId} dragged to position ({x}, {y})")