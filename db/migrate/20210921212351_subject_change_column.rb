class SubjectChangeColumn < ActiveRecord::Migration[6.1]
  def change
    remove_column :subjects, :subject_id
    rename_column :subjects, :id, :subject_id
  end
end
