class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :guest
  belongs_to :property
end
