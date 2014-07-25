class BaseController < ApplicationController

  def index
    render text: '', layout: 'front'
  end

  def ng_renderer
    render file: "angular/#{params[:path]}", layout: false
  end

end