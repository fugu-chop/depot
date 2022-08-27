class InsertPriceToLineItems < ActiveRecord::Migration[6.1]
  def up
    LineItem.all.each do |line_item|
      product_id = line_item.product_id.to_s
      price = Product.find_by(product_id).price
      line_item.price = price
      line_item.save!
    end
  end

  def down
    LineItem.all.each do |line_item|
      line_item.price = 0
      line_item.save!
    end
  end
end
