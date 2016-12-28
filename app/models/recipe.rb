class Recipe < ActiveRecord::Base
  has_many :instructions, dependent: :destroy
  has_many :reviews, dependent: :destroy
  belongs_to :user

  has_many :pantries
  has_many :ingredients, through: :pantries, dependent: :destroy

  has_many :recipe_categories
  has_many :categories, through: :recipe_categories, dependent: :destroy

  validates :user_id, presence: true
  validates :name, presence: true
  validates :description, presence: true

  # accepts_nested_attributes_for :instructions
  # accepts_nested_attributes_for :ingredients
  # accepts_nested_attributes_for :categories

  # def categories_attributes=(category_attributes)
  #   category_attributes.values.each do |category_attribute|
  #     category = Category.find_or_create_by(category_attribute)
  #     self.categories << category
  #   end
  # end

  # def instructions_attributes=(instruction_attributes)
  #   instruction_attributes.each do |i, instruction_attribute|
  #     if instruction_attribute[:content].present?
  #       instruction = Instruction.find_or_create_by(content: instruction_attribute[:content])
  #       if !self.instructions.include?(instruction)
  #         self.recipe_instructions.build(:instruction => instruction)
  #       end
  #     end
  #   end
  # end

  # def ingredients_attributes=(ingredient_attributes)
  #   ingredient_attributes.each do |i, attribute|
  #     if (!(attribute.values.any? &:blank?))
  #       ingredient = Ingredient.find_or_create_by(name: attribute['name'])
  #       self.recipe_ingredients.build(ingredient_id: ingredient.id, name: attribute['name'])
  #     end
  #   end
  # end

  def instructions_attributes=(instruction_attributes)
    instruction_attributes.values.each do |instruction_attribute|
      if instruction_attribute[:content].present?
        instruction = Instruction.find_or_create_by(instruction_attribute)
        self.instructions << instruction
      end
    end
  end

  def ingredients_attributes=(ingredient_attributes)
		ingredient_attributes.values.each do |ingredient_attribute|
			if ingredient_attribute[:name].length > 0
				ingredient = Ingredient.find_or_create_by(ingredient_attribute)
				self.ingredients << ingredient
			end
		end
	end

  def categories_attributes=(category_attributes)
      # {"0"=>{"name"=>"new category 1"}, "1"=>{"name"=>"new category 2"}}
      # how would I create a category for each of the hashes inside categories_hashes
      category_attributes.each do |i, category_attribute|
        # create a new category if this post doesn't already have this category
        # find or create the category regardless of whether this post has it...

        # DO NOT CREATE A CATEGORY IF IT DOESN'T NAME
        if category_attribute[:name].present?
          # But also don't add a category to a post if it already has it.
          # how do I check if this post has this category already?

          category = Category.find_or_create_by(name: category_attribute[:name])
          if !self.categories.include?(category)
            # why is this ineffecient and not ideal?
            # self.categories << category
            self.recipe_categories.build(:category => category)
            # I need to create a category that is already associated with this post
            # and I need to make sure that this category already doesn't exist by name.
          end
        end
      end
    end


end
