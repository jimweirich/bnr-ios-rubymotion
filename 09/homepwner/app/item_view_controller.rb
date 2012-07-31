class ItemsViewController < UITableViewController
  def initWithStyle(style)
    super(style)
  end

  def init
    initWithStyle(UITableViewStyleGrouped)
    5.times { ItemStore.shared_store.create_item }
    self
  end


  def tableView(table_view, numberOfRowsInSection: section)
    ItemStore.shared_store.items.size
  end

  def tableView(table_view, cellForRowAtIndexPath: path)
    cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: "UITableViewCell")
    p = ItemStore.shared_store.items[path.row]
    cell.textLabel.text = p.description
    cell
  end
end

