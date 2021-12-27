module CurrentMovieManagement
  def reset_current_movie
    current_movie = Movie.where(is_current: true).last
    current_movie.is_current = false
    current_movie.save
  end
end