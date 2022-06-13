class Booking < ApplicationRecord
  belongs_to :guest
  belongs_to :property
  has_one :caution, dependent: :destroy

  validates :lodgify_id, presence: true, uniqueness: true
end
