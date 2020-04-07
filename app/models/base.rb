class Base < ApplicationRecord
  validates :base_number,  presence: true, length: { maximum: 50 } 
  validates :base_name,  presence: true, length: { maximum: 50 } 
end
