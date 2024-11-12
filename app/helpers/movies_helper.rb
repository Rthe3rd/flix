module MoviesHelper

  def total_gross(movie)
    if movie.is_flop?
      "This movie is a total Flop!"
    else
      number_to_currency(movie.total_gross, precision: 0)
    end
  end

  def year_of(movie)
    # movie.released_on.strftime("%Y")
    movie.released_on.year
  end

  def average_stars(movie)
    if movie.average_stars.zero?
      content_tag(:strong, "No reviews")
    else
      pluralize(number_with_precision(movie.average_stars, precision: 1), "star")
      "*" * movie.average_stars.round
    end
  end

end
