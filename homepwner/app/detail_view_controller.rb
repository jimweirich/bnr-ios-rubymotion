class DetailViewController < UIViewController
  attr_reader :item

  def set_item(item)
    @item = item
    navigationItem.title = @item.item_name
  end

  def loadView
    super
    view.backgroundColor = UIColor.groupTableViewBackgroundColor
  end

  def viewDidLoad
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
    y = 5
    y, @name_label, @name_field = make_labelled_field(y, "Name", item.item_name)
    y, @serial_label, @serial_field = make_labelled_field(y, "Serial", item.serial_number)
    y, @value_label, @value_field = make_labelled_field(y, "Value", "$%1.2f" % item.value_in_dollars)
    @value_field.keyboardType = UIKeyboardTypeDecimalPad

    margin = 10
    height = 30

    @date_label = UILabel.alloc.init.tap do |w|
      w.frame           = [[margin, y], [view.bounds.size.width - 2*margin, height]]
      w.font            = UIFont.systemFontOfSize(14)
      w.text            = "Created on #{date_formatter.stringFromDate(item.date_created)}"
      w.textAlignment   = UITextAlignmentCenter
      w.textColor       = UIColor.whiteColor
      w.backgroundColor = UIColor.blackColor
      view.addSubview(w)
    end
  end

  def date_formatter
    @date_formatter ||= NSDateFormatter.alloc.init.tap do |f|
      f.setDateStyle(NSDateFormatterMediumStyle)
      f.setTimeStyle(NSDateFormatterNoStyle)
    end
  end

  def make_labelled_field(y, label, value)
    margin = 10
    split  = 60
    height = 40

    label = UILabel.alloc.init.tap do |w|
      w.frame           = [[margin, y], [split-margin, 0.8*height]]
      w.font            = UIFont.systemFontOfSize(14)
      w.text            = label
      w.textColor       = UIColor.whiteColor
      w.backgroundColor = UIColor.blackColor
      w.textAlignment   = UITextAlignmentLeft
      view.addSubview(w)
    end

    field = UITextField.alloc.init.tap do |w|
      w.frame           = [[split, y], [view.bounds.size.width - margin - split, 0.8*height]]
      w.textColor       = UIColor.blackColor
      w.backgroundColor = UIColor.whiteColor
      w.delegate        = self
      w.borderStyle     = UITextBorderStyleRoundedRect
      w.returnKeyType   = UIReturnKeyNext
      w.text            = value
      view.addSubview(w)
    end
    [y+height, label, field]
  end
end
