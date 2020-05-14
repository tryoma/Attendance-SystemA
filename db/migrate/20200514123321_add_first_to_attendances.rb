class AddFirstToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :first_started_at, :datetime
    add_column :attendances, :first_finished_at, :datetime
  end
end
