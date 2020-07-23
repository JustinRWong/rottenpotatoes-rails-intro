class Movie < ActiveRecord::Base
  attr_accessor :all_ratings

  def self.with_ratings(selected_ratings)
    Movie.where({rating: selected_ratings})
  end
    
end
