module RecipesHelper
  def user_id_field(recipe)
    if recipe.user.nil?
      select_tag "recipe[user_id]", options_from_collection_for_select(User.all, :id, :name)
    else
      hidden_field_tag "recipe[user_id]", recipe.user_id
    end
  end
end
