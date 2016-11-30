class CreateReciepeCategories < ActiveRecord::Migration
  def change
    create_table :reciepe_categories do |t|
      t.references :recipe, index: true, foreign_key: true
      t.references :category, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
