class AddCategoryIdToProducts < ActiveRecord::Migration
  def change
    add_reference(:products, :product_category, foreign_key: true)
  end
end
