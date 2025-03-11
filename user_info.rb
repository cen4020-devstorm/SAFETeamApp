class UserInfo < ApplicationRecord
    validates :name, :phone, :location, :destination, presence: true
    validates :phone, format: { with: /\A\d+\z/, message: "must only contain numbers" }
  end
  
