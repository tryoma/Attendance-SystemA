class AddKintaiToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :kintai_to_who, :string, default:" "
    add_column :attendances, :kintai_tomorrow, :boolean
  end
end
