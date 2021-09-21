class Lecture < ApplicationRecord
  belongs_to :subject
  validates :lecture_id, presence: true, uniqueness: true

end
