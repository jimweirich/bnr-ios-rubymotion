# -*- coding: utf-8 -*-
class Item
  attr_accessor :item_name, :serial_number, :value_in_dollars, :date_created

  def initialize(item_name = "Item", value_in_dollars = 0, serial_number = "")
    @item_name, @serial_number, @value_in_dollars = item_name, serial_number, value_in_dollars
    @date_created = Time.now
  end

  def to_s
    "#{item_name} (#{serial_number}): $%0.2f" % value_in_dollars
  end

  def self.random_item
    adjectives = ['Fluffy', 'Rusty', 'Shiny', 'Bulky', 'Nasty']
    nouns      = ['Bear', 'Spork', 'Mac', 'Tea', 'Coffee', 'Maté']
    name       = "#{adjectives.sample} #{nouns.sample}"

    charset = %w{ 0 1 2 3 4 5 6 7 8 9 A B C D E F G H I J K L M N O P Q R S T U V W X Y Z}
    serial  = (0...5).map{ charset.to_a[rand(charset.size)] }.join

    Item.new(name, rand(100), serial)
  end
end
