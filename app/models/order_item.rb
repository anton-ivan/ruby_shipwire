class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product

  validates :quantity, numericality: { greater_than: 0, integer_only: true }
  validates :price, presence: true, numericality: { greater_than: 0 }

  def total
    self.price * self.quantity
  end

  def weight
    (quantity.to_f * product.weight).round(2)
  end
end
