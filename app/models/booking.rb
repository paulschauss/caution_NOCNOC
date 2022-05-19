class Booking < ApplicationRecord
  belongs_to :guest
  belongs_to :property

  validates :lodgify_id, presence: true, uniqueness: true
end
