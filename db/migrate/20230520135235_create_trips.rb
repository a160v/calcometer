class CreateTrips < ActiveRecord::Migration[7.0]
  def change
    create_table :trips do |t|
      t.float :driving_distance
      t.float :driving_duration
      t.references :user, null: true, foreign_key: true

      t.timestamps
    end
  end
end
