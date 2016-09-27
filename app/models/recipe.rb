class Recipe < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: [:slugged, :history]

  has_many :ingredients, through: :recipe_ingredients
  has_many :recipe_ingredients
  belongs_to :category, class_name: 'RecipeCategory'

  accepts_nested_attributes_for :recipe_ingredients, allow_destroy: true, reject_if: :all_blank
end
