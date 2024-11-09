class Company::MainController < Company::ApplicationController
	def index
		render 'company/main/index.erb'
	end

	def index_cn
		render 'company/main/index_cn.erb'
	end

	def products
		@web_product_category = WebProductCategory.find(params[:cate])
		if @web_product_category.blank?
	    redirect_to '/'
		end
	end
end