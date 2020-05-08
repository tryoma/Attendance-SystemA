class AddChangeToApplies < ActiveRecord::Migration[5.1]
  def change
    add_column :applies, :change, :boolean
  end
end
