class CreateMovies < ActiveRecord::Migration[6.1]
  def change
    create_table :movies do |t|
      t.string :title
      t.text :thoughts
      t.integer :rating
      t.boolean :is_current

      t.timestamps
    end
  end
end
