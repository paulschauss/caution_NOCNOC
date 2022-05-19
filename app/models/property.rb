class Property < ApplicationRecord
  has_many :rooms, dependent: :destroy
end
