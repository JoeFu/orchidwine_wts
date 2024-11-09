class Admin::ContainersController < Admin::ApplicationController
  before_action :find_model

  def destroy
    @container.destroy
    @container.delivery.to_transition(@container.id)
    flash[:success] = '集装箱删除成功！'
    redirect_to "/admin/deliveries/#{@container.delivery_id}/manager"
  end

  private
  def find_model
    @container = Container.find(params[:id]) if params[:id]
  end
end
