class Guest < ApplicationRecord
  has_many :bookings, dependent: :destroy

  validates :lodgify_id, presence: true
end
