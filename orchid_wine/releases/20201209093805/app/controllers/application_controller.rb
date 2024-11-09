class ApplicationController < ActionController::Base
  helper :all

  def redirect(url, args = {})
    flash.merge!(args.slice(:error, :success))
    redirect_to url
  end
  
  def rende(path, args = {})
    flash.merge!(args.slice(:error, :success))
    render path
  end
end
