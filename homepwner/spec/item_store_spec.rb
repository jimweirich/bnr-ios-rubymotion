describe ItemStore do

  describe "the shared store" do
    it "is always the same object" do
      store1 = ItemStore.shared_store
      store2 = ItemStore.shared_store
      store1.should.equal(store2)
    end
  end

  describe "when empty" do
    before do
      @store = ItemStore.new
    end

    it "is initial empty" do
      @store.size.should == 0
    end

    it "adds a random item" do
      @store.create_item
      @store.size.should == 1
    end
  end

  describe "when creating items" do
  end

  describe "with some items" do
    def path(i)
      NSIndexPath.indexPathForRow(i, inSection: 0)
    end

    def item_ids
      @store.map { |item| item.serial_number.to_i }
    end

    before do
      @store = ItemStore.new
      @item1 = Item.new("ONE",   1.00, "00001")
      @item2 = Item.new("TWO",   2.00, "00002")
      @item3 = Item.new("THREE", 3.00, "00003")
      @item4 = Item.new("FOUR",  4.00, "00004")
      @store << @item1 << @item2 << @item3 << @item4

      @itemx = Item.new("X",  0.00, "00000")
    end

    it "reflects its size" do
      @store.size.should == 4
      item_ids.should == [1, 2, 3, 4]
    end

    it "fetchs its contents" do
      @store.size.should == 4
      @store[path(0)].should == @item1
      @store[path(1)].should == @item2
      @store[path(2)].should == @item3
      @store[path(3)].should == @item4
    end

    it "indexes items" do
      @store.index(@item1).should == 0
      @store.index(@item4).should == 3
      @store.index(@itemx).should == nil
    end

    it "removes items" do
      @store.remove(@item3)
      item_ids.should == [1, 2, 4]
    end

    it "moves items 2=>1" do
      @store.move(0, 1)
      item_ids.should == [2, 1, 3, 4]
    end

    it "moves items 1=>3" do
      @store.move(1, 3)
      item_ids.should == [1, 3, 4, 2]
    end
  end
end
