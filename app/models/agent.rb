class Agent < ActiveRecord::Base

  has_many :orders, as: :orderer, dependent: :destroy
  validates :name, presence: true

  validates :email, presence: true,
                    uniqueness: true,
                    format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i} 
end
