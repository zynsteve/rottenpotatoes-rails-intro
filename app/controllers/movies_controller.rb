class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie::RATINGS
    @sort = params[:sort] || session[:sort]
    @checked_ratings_hash = params[:ratings] || session[:ratings] || Hash[@all_ratings.map { |rating| [rating, true] }]
    if !params[:ratings] && !params[:sort]
      flash.keep
      redirect_to movies_path(:ratings => @checked_ratings_hash, :sort => @sort)
    end
    session[:ratings] = @checked_ratings_hash
    session[:sort] = @sort
    @movies = Movie.where(:rating => @checked_ratings_hash.keys).order(@sort)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
