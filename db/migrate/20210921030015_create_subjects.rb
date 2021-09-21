class CreateSubjects < ActiveRecord::Migration[6.1]
  def change
    create_table :subjects do |t|
      t.integer :subject_id
      t.references :teacher, foreign_key: true
      t.string :title
      t.string :weekday
      t.integer :period

      t.timestamps
    end
  end
end
