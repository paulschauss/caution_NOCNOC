class Property < ApplicationRecord
  has_many :rooms, dependent: :destroy
  has_many :bookings, dependent: :destroy

  validates :lodgify_id, presence: true, uniqueness: true
end
