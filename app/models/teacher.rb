class Teacher < ApplicationRecord
  has_many :subjects, dependent: :destroy
  validates :teacher_id, presence: true, uniqueness: true

end
