class Movie < ApplicationRecord

  has_many :reviews, dependent: :destroy

  validates :title, :released_on, :duration, presence: true

  validates :description, length: { minimum: 25 } 

  validates :total_gross, comparison: { greater_than_or_equal_to: 0 }

  RATINGS = %w(G PG PG-13 R NC-17)
  validates :rating, inclusion: { in: RATINGS, message: "Not a valid rating"}

  def self.released
    where('released_on < ?', Time.now).order(released_on: :desc)
  end

  def is_flop?
    total_gross.blank? || total_gross < 225000000
  end

end 
