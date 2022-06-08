class Caution < ApplicationRecord
  belongs_to :booking

  validates :name, :amount, presence: true
end
