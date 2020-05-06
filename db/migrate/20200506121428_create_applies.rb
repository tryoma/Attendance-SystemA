class CreateApplies < ActiveRecord::Migration[5.1]
  def change
    create_table :applies do |t|
      t.date :month
      t.string :month_instructor_confirmation, default:"選択してください"
      t.string :month_to_who
      t.string :mark_month_instructor_confirmation, default:"申請中"
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
