class Movie < ApplicationRecord
  belongs_to :user
  
  validates_presence_of :title, :thoughts, :rating
  validates :user, presence: true
  validates :title, length: {minimum: 3, maximum: 25}
  validates :thoughts, length: {minimum: 5, maximum: 100}
  validates :rating, inclusion: { in: [1, 2, 3, 4, 5] }
  validates :is_current, inclusion: [true, false]
end
