class ItemsViewController < UITableViewController
  def init
    initWithStyle(UITableViewStyleGrouped)
    navigationItem.title = "Homepwner"
    right_button = UIBarButtonItem.alloc.
      initWithBarButtonSystemItem(UIBarButtonSystemItemAdd, target: self, action: "addNewItem:")
    navigationItem.setRightBarButtonItem(right_button)
    navigationItem.setLeftBarButtonItem(editButtonItem)
    self
  end

  def loadView
    super
    view.bounds = CGRectMake(20, 0, 320, 480)
  end

  def viewWillAppear(animated)
    super
    tableView.reloadData
  end

  # Actions

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

  # Table View Protocol

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

  def tableView(tv, didSelectRowAtIndexPath: path)
    item = ItemStore.shared_store[path]
    detail_view_controller = DetailViewController.alloc.init
    detail_view_controller.set_item(item)
    navigationController.pushViewController(detail_view_controller, animated: true)
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
