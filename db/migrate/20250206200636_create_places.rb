class CreatePlaces < ActiveRecord::Migration[7.2]
  def change
    create_table :places do |t|
      t.string :name, null: false
      t.string :address, null: false
      t.string :postal_code, null: false

      t.timestamps
    end

    add_index :places, :name, unique: true
  end
end
