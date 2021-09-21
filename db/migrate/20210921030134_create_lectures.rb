class CreateLectures < ActiveRecord::Migration[6.1]
  def change
    create_table :lectures do |t|
      t.integer :lecture_id
      t.references :subject, foreign_key: true
      t.string :title
      t.date :date

      t.timestamps
    end
  end
end
