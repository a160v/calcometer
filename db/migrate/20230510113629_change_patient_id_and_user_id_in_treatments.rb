class ChangePatientIdAndUserIdInTreatments < ActiveRecord::Migration[7.0]
  def change
    change_column_null :treatments, :patient_id, true
    change_column_null :treatments, :user_id, true
  end
end
