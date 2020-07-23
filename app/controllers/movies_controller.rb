class MoviesController < ApplicationController
  helper_method :sort_column, :sort_direction
  
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.distinct.pluck(:rating)
    session[:ratings] = params[:ratings] if params[:ratings]
    session[:sort] = params[:sort] if params[:sort]
    
    if session[:ratings] || session[:sort]
        case session[:sort]
            when "title"
                ## sort by title
                @title_hilite = "hilite" 
            when "release_date"
                @release_hilite = "hilite"
        end
        
        
        session[:ratings] ||= @all_ratings ## default to all ratings if not specified
        @ratings = session[:ratings]
        @ratings = @ratings.keys if @ratings.respond_to?(:keys)
#             @ratings = @ratings.keys if :rating in session[:ratings] end
#         end 
#         @movies = Movie.where("rating = ? ", session[:ratings].keys).all.order(sort_column + " " + sort_direction)
#         @movies = Movie.find(:all, order: session[:sort], conditions: ["rating IN (?)", @ratings])
        @movies = Movie.where(rating: @ratings).all.order(sort_column + " " + sort_direction)
    else
#     if params[:ratings]
#         @movies = Movie.with_ratings(params[:ratings].keys)
#     else
        @movies = Movie.all
    end
      
#     if params[:sort]
#         @movies = Movie.order(sort_column + " " + sort_direction)
#     end 
    if session[:ratings] != params[:ratings] || session[:sort] != params[:sort]
        ## if there's a mismatch in the session and param, parameter takes precendence
        redirect_to movies_path(ratings: session[:ratings], sort: session[:sort])
    end 
  end
    
  def sort_column
    Movie.column_names.include?(params[:sort]) ? params[:sort] : "title"
  end
    
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
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