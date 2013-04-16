class DetailViewController < UIViewController
  attr_reader :item

  def set_item(item)
    @item = item
  end

  def loadView
    super
    view.backgroundColor = UIColor.groupTableViewBackgroundColor
  end

  def viewDidLoad
    @nameField = "BOB"
    make_detail_view
  end

  def viewWillDisappear(animated)
    super
    view.endEditing(true)
    item.item_name = @name_field.text
    item.serial_number = @serial_field.text
    item.value_in_dollars = @value_field.text.sub(/\$/,'').to_f
  end

  private

  def make_detail_view
    y = 0
    y, @name_label, @name_field = make_labelled_field(y, "Name", item.item_name)
    y, @serial_label, @serial_field = make_labelled_field(y, "Serial", item.serial_number)
    y, @value_label, @value_field = make_labelled_field(y, "Value", "$%1.2f" % item.value_in_dollars)

    margin = 10
    height = 30

    @date_label = UILabel.alloc.init.tap do |w|
      w.frame = [[margin, y], [view.bounds.size.width - 2*margin, height]]
      w.font = UIFont.systemFontOfSize(20)
      date_formatter = NSDateFormatter.alloc.init
      date_formatter.setDateStyle(NSDateFormatterMediumStyle)
      date_formatter.setTimeStyle(NSDateFormatterNoStyle)
      w.text = date_formatter.stringFromDate(item.date_created)
      w.textAlignment = UITextAlignmentCenter
      view.addSubview(w)
    end
  end

  def make_labelled_field(y, label, value)
    margin = 10
    split = 100
    height = 30

    label = UILabel.alloc.init.tap do |w|
      w.frame = [[margin, y], [split-margin, height]]
      w.font = UIFont.systemFontOfSize(20)
      w.text = label
      w.textAlignment = UITextAlignmentLeft
      view.addSubview(w)
    end

    field = UITextField.alloc.init.tap do |w|
      w.frame = [[split, y], [view.bounds.size.width - margin - split, height]]
      w.textColor = UIColor.blackColor
      w.backgroundColor = UIColor.whiteColor
      w.delegate = self
      w.text = value
      view.addSubview(w)
    end
    [y+height, label, field]
  end
end
