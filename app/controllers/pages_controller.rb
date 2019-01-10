class PagesController < ApplicationController
  skip_load_and_authorize_resource class: false
  def pages
    authorize! :read
  end
end