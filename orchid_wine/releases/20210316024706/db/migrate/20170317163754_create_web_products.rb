# encoding: utf-8
class CreateWebProducts  < ActiveRecord::Migration[5.1]
  def change
    create_table(:web_products, :options => 'ENGINE=MyISAM DEFAULT CHARSET=utf8mb4') do |t|
     
      t.string :name
      
      t.integer :web_product_category_id
      t.string :score # 评分：9.7 
      t.string :cover
      t.string :pdf

      t.text :grape_variety # 萄品种：西拉子 ／光照时间：1900小时
      t.text :grape_area # 萄产区：南澳大利亚迈凯伦山谷 ／经纬度：S44°50′
      t.text :wine_maker # 酒师：Dereck
      t.text :taste # 口滋味：醋栗，黑浆果，巧克力，黑胡椒 ／酒体：饱满
      t.text :match # 饮搭配：煎炒类牛排，酱汁浓郁的菜系，比如川菜及鲁菜 ／饮用温度：10℃～15℃
      t.text :feature # 品特点：

      t.timestamps
    end
  end
end