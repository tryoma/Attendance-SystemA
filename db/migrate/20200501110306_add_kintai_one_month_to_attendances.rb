class AddKintaiOneMonthToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :kintai_change_instructor_confirmation, :string, default:"選択してください"
    add_column :attendances, :mark_kintai_change_instructor_confirmation, :string, default:"なし"
  end
end
