class ItemStore
  include Enumerable

  def self.shared_store
    @shared_store ||= new
  end

  def initialize
    @items = []
    self
  end

  def create_item
    item = Item.random_item
    self << item
    item
  end

  def size
    @items.size
  end

  def [](path)
    @items[path.row]
  end

  def <<(item)
    @items << item
  end

  def remove(item)
    @items.delete_if { |it| it.equal?(item) }
  end

  def move(from, to)
    item = @items.delete_at(from)
    @items.insert(to, item)
  end

  def index(item)
    @items.index(item)
  end

  def each(&block)
    @items.each(&block)
  end
end
