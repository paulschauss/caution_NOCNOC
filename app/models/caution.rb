class Caution < ApplicationRecord
  validates :name, :price, presence: true
end
