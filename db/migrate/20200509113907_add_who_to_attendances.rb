class AddWhoToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :zangyou_to_who, :string, default:" "
  end
end
