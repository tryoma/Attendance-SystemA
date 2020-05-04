class AddMarkInstructorConfirmationToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :mark_instructor_confirmation, :string, default:"なし"
  end
end
