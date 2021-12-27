class MoviesController < ApplicationController
  include CurrentMovieManagement

  before_action :find_movie, only: [:show, :update, :destroy]

  def index
    @movies = Movie.all
    render json: @movies
  end

  def show
    render json: @movie
  end

  def create
    @movie = Movie.new(movie_params)

    if(@movie.is_current == true)
      reset_current_movie
    end

    if(@movie.save)
      render json: @movie, status: :created
    else
      render json: @movie.errors.full_messages,  status: 422
    end
  end

  def update
    if(movie_params[:is_current] == "true")
      reset_current_movie
    end

    if(@movie.update(movie_params))
      render json: @movie
    else
      render json: @movie.errors.full_messages, status: 422
    end
  end

  def destroy
    if @movie.destroy
      render json: { message: "Movie Successfully Deleted" }, status: 200
    end
  end

  private

  def movie_params
    params.require(:movie).permit(:title, :thoughts, :rating, :is_current)
  end

  def find_movie
    begin
      @movie = Movie.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Movie does not exist" }, status: 404
    end
  end
end