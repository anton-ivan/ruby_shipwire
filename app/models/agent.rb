class Agent < ActiveRecord::Base

  has_many :orders, as: :orderer, dependent: :destroy
  validates :name, presence: true 
end
