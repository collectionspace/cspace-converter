class SitesController < ApplicationController

  def index
  end

  def connection
  end

  def nuke
    CollectionSpace::Converter::Nuke.everything!
    flash[:notice] = "Database nuked, all records deleted!"
    redirect_to root_path
  end

end
