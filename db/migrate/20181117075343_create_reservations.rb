class CreateReservations < ActiveRecord::Migration[5.2]
  def change
    create_table :reservations do |t|
      t.references :restaurant,  foreign_key: { on_delete: :cascade }, null: false
      t.references :guest,       foreign_key: { on_delete: :cascade }, null: false
      t.integer    :status,      null: false, default: 0
      t.datetime   :start_time,  null: false
      t.integer    :covers,      null: false, default: 1
      t.text       :note

      t.timestamps
    end
  end
end
