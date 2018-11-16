class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string  :first_name,      null: false
      t.string  :last_name,       null: false
      t.string  :email,           null: false
      t.string  :password_digest, null: false
      t.integer :role,            null: false, default: 1

      t.timestamps

      t.index 'LOWER(email)', unique: true
    end
  end
end
