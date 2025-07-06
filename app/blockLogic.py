from PySide6.QtCore import QObject, Property, Signal, Slot
from widgets.simpleBlockElement import SimpleBlockElement

class BlockLogic(QObject):
    connectBlock = Signal(int, int)
    disconnectBlock = Signal(int, int)

    addBlockRequested = Signal()
    blockAdded = Signal(int)
    blockRemoved = Signal(int)

    def __init__(self, parent=None):
        super().__init__(parent)
        self._blocks = {}

    @Property(dict, constant=True)
    def blocks(self):
        return self._blocks
    
    @Slot(int, result=QObject)
    def getBlock(self, blockId):
        """
        Returns the block with the given blockId.
        """
        return self._blocks.get(blockId, None)
    
    @Slot(SimpleBlockElement)
    def addBlock(self, block):
        """
        Adds a new block to the logic.
        """
        if not isinstance(block, SimpleBlockElement):
            raise TypeError("Expected a SimpleBlockElement instance.")
        
        self._blocks[block.blockId] = block
        self.blockAdded.emit(block.blockId)

    @Slot(int)
    def removeBlock(self, blockId):
        """
        Removes the block with the given blockId.
        """
        if blockId in self._blocks:
            del self._blocks[blockId]
            self.blockRemoved.emit(blockId)
        else:
            raise KeyError(f"Block with id {blockId} does not exist.")


