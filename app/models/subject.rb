class Subject < ApplicationRecord
  has_many :lectures, dependent: :destroy
  belongs_to :teacher
  validates :subject_id, presence: true, uniqueness: true

end
