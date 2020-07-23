class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
    
  def sortable(column, title = nil)
    title ||= column.titlesize
    ## determine css class based on if the sort_column tag was passed
    css_class = column == sort_column ? "hilite" : nil
      
    ## determine sort direction based on param
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    
    ## set it as a link that toggles direction and class 
    link_to title, {:sort => column, :direction => direction}, {:class => css_class}
  end
end
