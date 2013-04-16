class ItemsViewController < UITableViewController
  def init
    initWithStyle(UITableViewStyleGrouped)
     self
  end

  def loadView
    super
    view.bounds = CGRectMake(20, 0, 320, 480)
  end

  def make_header_view
    header_view = UIView.alloc.init
    header_view.frame = CGRectMake(0, 20, 180, 50)
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
      sender.setTitle("Edit", forState: UIControlStateNormal)
      setEditing(false, animated: true)
    else
      sender.setTitle("Done", forState: UIControlStateNormal)
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

  def tableView(tv, commitEditingStyle: style, forRowAtIndexPath: path)
    if style == UITableViewCellEditingStyleDelete
      item = ItemStore.shared_store[path]
      ItemStore.shared_store.remove(item)
      tv.deleteRowsAtIndexPaths([path], withRowAnimation: UITableViewRowAnimationFade)
    end
  end

  def tableView(tv, moveRowAtIndexPath: sourceIndexPath, toIndexPath: destIndexPath)
    ItemStore.shared_store.move(sourceIndexPath.row, destIndexPath.row)
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
