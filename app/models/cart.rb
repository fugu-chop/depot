class Cart < ApplicationRecord
  has_many :line_items, dependent: :destroy

  def add_product(product)
    current_item = find_current_item(product)
    if current_item
      current_item.quantity += 1 
    else
      current_item = line_items.build(product_id: product.id, price: product.price) 
    end
    current_item
  end

  def reduce_quantity(product)
    current_item = find_current_item(product)
    current_item.quantity -= 1 
    current_item
  end

  def total_price
    line_items.to_a.sum { |item| item.total_price }
  end

  private
  
  def find_current_item(product)
    line_items.find_by(product_id: product.id)
  end
end
