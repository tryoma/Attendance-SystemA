class AddTomorrowToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :tomorrow, :boolean
  end
end
