class CreateRestaurants < ActiveRecord::Migration[5.2]
  def change
    create_table :restaurants do |t|
      t.references :manager,    foreign_key: { to_table: :users, on_delete: :cascade }, null: false
      t.string :name,           null: false
      t.string :phone,          null: false
      t.string :email,          null: false
      t.text   :location,       null: false
      t.string :opening_hours,  null: false, array: true
      t.string :cuisines,       null: false, array: true

      t.timestamps

      t.index :name
      t.index :cuisines
    end
  end
end
