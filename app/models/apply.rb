class Apply < ApplicationRecord
  belongs_to :user
  
  validates :worked_on, presence: true
end
