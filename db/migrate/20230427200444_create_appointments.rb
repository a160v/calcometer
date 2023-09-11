class CreateAppointments < ActiveRecord::Migration[7.0]
  def change
    create_table :appointments do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.references :user, null: true, foreign_key: true
      t.references :patient, null: true, foreign_key: true
      t.references :address, null: true, foreign_key: true
      t.references :client, null: false, foreign_key: true

      t.timestamps
    end
  end
end
