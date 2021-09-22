class LectureChangeColumn < ActiveRecord::Migration[6.1]
  def change
    remove_column :lectures, :lecture_id
    rename_column :lectures, :id, :lecture_id
  end
end
