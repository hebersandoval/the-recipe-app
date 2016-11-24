###creating a review under a recipe when resources are nested

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

with this in place, the `recipe_id` will be allowed for mass assignment in the `create` action. no need to pass the `:create` option to the nested resources because the `form_for(@review)` helper in `views/reviews/new.html.erb` will automatically route to `POST`, which will trigger `reviews_controller#create` action for a new `Review`.
