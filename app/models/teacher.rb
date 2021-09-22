class Teacher < ApplicationRecord
  has_many :subjects, dependent: :destroy
  validates :teacher_id, presence: true, uniqueness: true

  def self.search(keyword)
    Teacher.where("name LIKE (?)", "%#{keyword}%")
  end
end
