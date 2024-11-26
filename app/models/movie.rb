class Movie < ApplicationRecord

  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :fans, through: :favorites, source: :user
  has_many :critics, through: :reviews, source: :user

  has_many :characterizations, dependent: :destroy
  has_many :genres, through: :characterizations

  validates :title, :released_on, :duration, presence: true

  validates :description, length: { minimum: 25 } 

  validates :total_gross, comparison: { greater_than_or_equal_to: 0 }

  RATINGS = %w(G PG PG-13 R NC-17)
  validates :rating, inclusion: { in: RATINGS, message: "Not a valid rating"}

  def self.released
    where('released_on < ?', Time.now).order(released_on: :desc)
  end

  def is_flop?
    unless (reviews.count > 50 && average_stars >= 4)
      total_gross.blank? || total_gross < 225000000
    end
  end

  def average_stars
    reviews.average(:stars) || 0.0
  end

  def average_stars_as_percent
    (self.average_stars / 5) * 100
  end

end 
