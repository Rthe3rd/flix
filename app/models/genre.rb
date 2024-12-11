class Genre < ApplicationRecord

  validates :name, presence: true, uniqueness: true

  has_many :characterizations, dependent: :destroy
  has_many :movies, through: :characterizations

  def to_param
    genre
  end

  def format_genre
    self.genre = genre.parameterize
  end

end
