class CreateTrips < ActiveRecord::Migration[7.0]
  def change
    create_table :trips do |t|
      t.references :start_appointment, null: false, foreign_key: { to_table: :appointments }
      t.references :end_appointment, null: false, foreign_key: { to_table: :appointments }
      t.float :driving_distance
      t.integer :driving_duration

      t.timestamps
    end
  end
end
