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
    positionChanged = Signal(float, float)
    onWidthChanged = Signal(float)
    onHeightChanged = Signal(float)

    lastBlockId = 0

    def __init__(self, text="Default Text", color="blue", inputSize=1, outputSize=1, parent=None):
        super().__init__(parent)
        self._text = text
        self._color = color
        self._inputSize = inputSize
        self._outputSize = outputSize
        self._blockId = SimpleBlockElement.lastBlockId
        self._x = 0.0
        self._y = 0.0
        self._width = 100.0
        self._height = 50.0
        SimpleBlockElement.lastBlockId += 1

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
        self._x = x
        self._y = y

    @Property(int, notify=positionChanged)
    def x(self):
        return self._x
    @x.setter
    def x(self, value):
        if self._x != value:
            self._x = value
            self.positionChanged.emit(self._x, self._y)

    @Property(int, notify=positionChanged)
    def y(self):
        return self._y
    @y.setter
    def y(self, value):
        if self._y != value:
            self._y = value
            self.positionChanged.emit(self._x, self._y)

    @Property(float, notify=onWidthChanged)
    def width(self):
        return self._width
    @width.setter
    def width(self, value):
        if value < 0:
            raise ValueError("Width cannot be negative.")
        if self._width != value:
            self._width = value
    @Property(float, notify=onHeightChanged)
    def height(self):
        return self._height
    @height.setter
    def height(self, value):
        if value < 0:
            raise ValueError("Height cannot be negative.")
        if self._height != value:
            self._height = value