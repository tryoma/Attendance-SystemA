class RenameEmplyeeNumberColumnToUsers < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :emplyee_number, :employee_number
  end
end
