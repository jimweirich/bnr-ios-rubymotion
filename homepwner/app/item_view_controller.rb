class ItemsViewController < UITableViewController
  def init
    initWithStyle(UITableViewStyleGrouped)
    self
  end

  def make_header_view
    header_view = UIView.alloc.init
    header_view.frame = CGRectMake(0, 0, 180, 50)
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    button.setTitle("Edit", forState:UIControlStateNormal)
    button.addTarget(self, action: "toggleEditingMode:", forControlEvents:UIControlEventTouchUpInside)
    button.frame = CGRectMake(10, 20, 150, 30)
    header_view.addSubview(button)
    button2 = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    button2 = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    button2.setTitle("New", forState:UIControlStateNormal)
    button2.addTarget(self, action: "addNewItem:", forControlEvents:UIControlEventTouchUpInside)
    button2.frame = CGRectMake(160, 20, 150, 30)
    header_view.addSubview(button2)
    header_view
  end

  def addNewItem(sender)
    item = ItemStore.shared_store.create_item
    row = ItemStore.shared_store.index(item)
    path = NSIndexPath.indexPathForRow(row, inSection: 0)
    tableView.insertRowsAtIndexPaths([path], withRowAnimation: UITableViewRowAnimationTop)
  end

  def toggleEditingMode(sender)
    if isEditing
      sender.setTitle("Done", forState: UIControlStateNormal)
      setEditing(false, animated: true)
    else
      sender.setTitle("Edit", forState: UIControlStateNormal)
      setEditing(true, animated: true)
    end
  end

  def headerView
    @header_view ||= make_header_view
  end

  def tableView(tv, viewForHeaderInSection: sec)
    headerView
  end

  def tableView(tv, heightForHeaderInSection: sec)
    headerView.bounds.size.height
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
