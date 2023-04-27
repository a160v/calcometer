class CreateVehicles < ActiveRecord::Migration[7.0]
  def change
    create_table :vehicles do |t|
      t.string :manufacturer
      t.string :model
      t.string :type
      t.string :fuel
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
