class ItemStore
  def self.shared_store
    @shared_store ||= allocWithZone(nil).init
  end

  def init
    @items = []
    self
  end

  def create_item
    item = Item.randomItem
    self << item
    item
  end

  def size
    @items.size + 1
  end

  def [](path)
    if path.row >= @items.size
      last_item
    else
      @items[path.row]
    end
  end

  def <<(item)
    @items << item
  end

  private

  class LastItem < Item
    def initialize
      super
    end
    def description
      "No More Items"
    end
  end


  def last_item
    @last_item ||= LastItem.new
  end
end
