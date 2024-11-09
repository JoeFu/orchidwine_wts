class Admin::ProductionsController < Admin::ApplicationController
  before_action :find_model

  private
  def find_model
    @production = Production.find(params[:id]) if params[:id]
  end
end
