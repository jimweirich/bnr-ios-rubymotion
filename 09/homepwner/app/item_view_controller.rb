class ItemsViewController < UITableViewController
  def init
    initWithStyle(UITableViewStyleGrouped)
    50.times { ItemStore.shared_store.create_item }
    self
  end

  def tableView(table_view, numberOfRowsInSection: section)
    ItemStore.shared_store.size
  end

  def tableView(table_view, cellForRowAtIndexPath: path)
    cell = reuse_cell(table_view) || new_cell(table_view)
    p = ItemStore.shared_store[path]
    cell.textLabel.text = p.description
    cell
  end

  private

  REUSE_ID = "UITableViewCell"

  def reuse_cell(table_view)
    table_view.dequeueReusableCellWithIdentifier(REUSE_ID)
  end

  def new_cell(table_view)
    UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: REUSE_ID)
  end
end
