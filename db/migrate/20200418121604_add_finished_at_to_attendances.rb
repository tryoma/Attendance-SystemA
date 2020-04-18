class AddFinishedAtToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :plan_finished_at, :datetime
    add_column :attendances, :business_processing_contents, :string
    add_column :attendances, :instructor_confirmation, :string
  end
end
