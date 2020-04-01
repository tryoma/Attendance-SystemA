class CreateBases < ActiveRecord::Migration[5.1]
  def change
    create_table :bases do |t|
      t.integer :base_number
      t.string :base_name
      t.string :base_type
      t.string :note

      t.timestamps
    end
  end
end
