# -*- coding: utf-8 -*-
describe Item do
  before do
    @item = Item.new("ITEM", 123.0, "ABC12")
  end

  it "has attributes" do
    @item.item_name.should == "ITEM"
    @item.serial_number.should == "ABC12"
    @item.value_in_dollars.should == 123.00
  end

  it "has a created date" do
    today = Time.now
    @item.date_created.year.should  == today.year
    @item.date_created.month.should == today.month
    @item.date_created.day.should   == today.day
  end

  it "has a description" do
    @item.to_s.should == "ITEM (ABC12): $123.00"
  end

  it "generates random items" do
    @item = Item.random_item
    @item.to_s.should =~ /^(Fluffy|Rusty|Shiny|Bulky|Nasty)/
    @item.to_s.should =~ /(Bear|Spork|Mac|Tea|Coffee|Maté)/
    @item.to_s.should =~ /\([A-Z0-9]{5}\)/
  end

end
