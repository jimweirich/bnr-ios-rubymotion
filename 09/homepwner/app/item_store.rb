class ItemStore
  def self.shared_store
    @shared_store ||= allocWithZone(nil).init
  end

  def init
    @items = []
    self
  end

  def items
    @items
  end

  def create_item
    item = Item.randomItem
    items << item
    item
  end
end
