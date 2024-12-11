class Movie < ApplicationRecord

  before_save :set_slug

  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :fans, through: :favorites, source: :user
  has_many :critics, through: :reviews, source: :user

  has_many :characterizations, dependent: :destroy
  has_many :genres, through: :characterizations

  validates :title, presence: true, uniqueness: true
  validates :released_on, :duration, presence: true

  validates :description, length: { minimum: 25 } 

  validates :total_gross, comparison: { greater_than_or_equal_to: 0 }

  RATINGS = %w(G PG PG-13 R NC-17)
  validates :rating, inclusion: { in: RATINGS, message: "Not a valid rating"}

  # scope :out_of_print, -> { where(out_of_print: true) }
  scope :released, -> { where("released_on < ?", Time.now).order("released_on desc") }
  scope :upcoming, -> { where("released_on > ?", Time.now).order("released_on asc") }
  scope :recent, -> (max=5){ released.limit(max) }
  scope :hits, -> { released.where("total_gross >= 3000000").order("total_gross desc") }
  scope :flops, -> { released.where("total_gross < 225000000").order("total_gross asc") }
  scope :grossed_less_than, -> (amount){ released.where("total_gross < ?", amount).order("total_gross asc") }
  scope :grossed_greater_than, -> (amount){ released.where("total_gross > ?", amount).order("total_gross asc") }
 

  # def self.released
  #   where('released_on < ?', Time.now).order(released_on: :desc)
  # end

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

  def to_param
    slug
  end

  private
  # note you are setting the slug attribute (self.slug) vs. just some variable named slug
    def set_slug
      self.slug = title.parameterize
    end

end 
