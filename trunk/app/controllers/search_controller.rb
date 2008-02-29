class SearchController < ApplicationController

  def index
    redirect_to :action => 'search'
  end
  
  def search
  end

  def results
    @q = params[:q]
    @talks = Talk.ferret_find(@q) if @q rescue nil
    @talks ||= []
  end
end
