###creating a review under a recipe when routes are nested

```ruby
# config/routes.rb

resources :authors, only: [:show, :index] do
  resources :posts, only: [:show, :index, :new]
end
```

then, update the reviews_controller#new action to handle `:recipe_id` parameter.

```ruby
# controllers/reviews_controller.rb

def new
  @review = Review.new(recipe_id: params[:recipe_id])
end
```

from the recipe's show page, create a helper link to `recipes/:id/reviews/new`

```
# <!-- recipes/show.html.erb -->

<%= link_to "New Review", new_recipe_review_path(@recipe) %>
```

here is the form with a `hidden_field` that will ensure that the `recipe_id` get recorded in params

```
<h1>New Review</h1>

<%= form_for @review do |f| %>

  <%= f.hidden_field :recipe_id %>
  <%= f.label :content %>
  <%= f.text_area :content %>

  <%= f.submit %>

<% end %>
```

the `html` that the `form_for` builder makes. can see that the `recipe_id` is being saved

```html
<form class="new_review" id="new_review" action="/reviews" accept-charset="UTF-8" method="post"><input name="utf8" type="hidden" value="&#x2713;" /><input type="hidden" name="authenticity_token" value="mJ0PBKIxP/3DRCY+sXysckbKvocmJQwa6GmB+1tvQZnXcAeNfNTU0y0ibErvZFu2Uys+3pf75wLqpCKU0v29cg==" />

  <input type="hidden" value="1" name="review[recipe_id]" id="review_recipe_id" />
  <label for="review_content">Content</label>
  <textarea name="review[content]" id="review_content">
</textarea>

  <input type="submit" name="commit" value="Create Review" />

</form>
```

now, need to carry that `recipe_id` even further to the `reviews_controller`, so that it accepts `:recipe_id` in the `review_params` method

```ruby
# controllers/reviews_controller.rb

def review_params
  params.require(:review).permit(:content, :recipe_id)
end
```

with this in place, the `recipe_id` will be allowed for mass assignment in the `create` action. no need to pass the `:create` option to the nested route because the `form_for(@review)` helper in `views/reviews/new.html.erb` will automatically route to `POST`, which will trigger `reviews_controller#create` action for a new `Review`.

###editing a recipe's review

make the following change

```ruby
# config/routes.rb

resources :authors, only: [:show, :index] do
  resources :posts, only: [:show, :index, :new, :edit]
end
```

and in the review's show page

```ruby
<h1>Review</h1>

<p>Recipe: <%= link_to @review.recipe.name, recipe_reviews_path(@review.recipe) if @review.recipe %> (<%= link_to "Edit Review", edit_recipe_review_path(@review.recipe, @review) if @review.recipe %>)</p>

<p><%= @review.content %></p>
```

the `reviews_controller#edit` action will need to check that a recipe exists and a review belongs to the recipe.

```ruby
def edit
  if params[:recipe_id]
    recipe = Recipe.find_by(id: params[:recipe_id])
    if recipe.nil?
      redirect_to to recipes_path, alert: "Recipe not found!"
    else
      @review = recipe.reviews.find_by(id: params[:id])
      redirect_to recipe_reviews_path(recipe), alert: "Review not found!" if @review.nil?
    end
  else
    @review = Review.find(params[:id])
  end
end
```

first, `params[:recipe_id]` is coming from the nested route, then it finds a valid recipe. If it can't, redirect to `recipes_path`. If a recipe is found, find the review by `params[:id]`, but not before filtering through `recipe.reviews` collection, so no invalid request get processed.

lets do the same to the `reviews_controller#new` action.

```ruby
# controllers/reviews_controller.rb

def new
  if params[:recipe_id] && !Recipe.exists?(params[:recipe_id])
    redirect_to recipes_path, alert: "Recipe not found!"
  else
    @review = Review.new(recipe_id: params[:recipe_id])
  end
end
```

we're checking for `params[:recipe_id]` and if `Recipe.exists?` to see if the author is real.

Since the `reviews/new` path can be accesed outside the context of a nested route, we can select from the recipes in the drop down menu. This gives us a select control if we don't have a recipe

```html
<h1>New Review</h1>

<%= form_for @review do |f| %>

  <!-- when submitting form with nested resources, hidden_field helps its value gets back to the server. -->
  <%= f.hidden_field :recipe_id %>
  <%= f.label :content %><br>
  <%= f.text_area :content %><br>
  <% if @review.recipe.nil? %>
    <p>Select recipe: <%= f.select :recipe_id, options_from_collection_for_select(Recipe.all, :id, :name) %></p>
  <% end %>

  <%= f.submit %>

<% end %>
```

but this can get messy, so let move it to a module

```ruby
# helpers/reviews_helper.rb

module ReviewsHelper
  def recipe_id_field(review)
    if review.recipe.nil?
      select_tag "review[recipe_id]", options_from_collection_for_select(Recipe.all, :id, :name)
    else
      hidden_field_tag "review[recipe_id]", review.recipe_id
    end
  end
end
```

now the `reviews/new` form looks like this:

```html
<h1>New Review</h1>

<%= form_for @review do |f| %>

  <%= f.label :content %><br>
  <%= f.text_area :content %><br>
  <p><%= recipe_id_field(@review) %></p>

  <%= f.submit %>

<% end %>
```
