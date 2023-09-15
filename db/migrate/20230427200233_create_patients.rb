class CreatePatients < ActiveRecord::Migration[7.0]
  def change
    create_table :patients do |t|
      t.string :name
      t.references :address, null: false, foreign_key: true

      t.timestamps
    end
  end
end
