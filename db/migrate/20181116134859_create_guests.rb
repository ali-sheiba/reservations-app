class CreateGuests < ActiveRecord::Migration[5.2]
  def change
    create_table :guests do |t|
      t.string :first_name, null: false
      t.string :last_name,  null: false
      t.string :phone,      null: false
      t.string :email,      null: false

      t.timestamps

      t.index :phone
      t.index :email
    end
  end
end
