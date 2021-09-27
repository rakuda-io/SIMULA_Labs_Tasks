class Teacher < ApplicationRecord
  has_many :subjects, dependent: :destroy
  validates :teacher_id, presence: true, uniqueness: true

  def self.name_search(teacher_name)
    Teacher.where("name LIKE ?", "%#{teacher_name}%")
  end
end
