class Guest < ApplicationRecord
  has_many :bookings, dependent: :destroy
end
