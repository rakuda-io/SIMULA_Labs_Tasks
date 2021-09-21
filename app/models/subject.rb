class Subject < ApplicationRecord
  has_many :lectures, dependent: :destroy
  belongs_to :teacher

end
