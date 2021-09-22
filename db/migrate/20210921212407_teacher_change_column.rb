class TeacherChangeColumn < ActiveRecord::Migration[6.1]
  def change
    remove_column :teachers, :teacher_id
    rename_column :teachers, :id, :teacher_id
  end
end
