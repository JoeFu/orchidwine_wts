# encoding: utf-8
class WebProductCategory < ApplicationRecord
	has_many :web_products

	def self.all_pluck
		WebProductCategory.all.pluck(:id, :name)
	end
end