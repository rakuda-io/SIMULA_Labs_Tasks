class Subject < ApplicationRecord
  has_many :lectures, dependent: :destroy
  belongs_to :teacher
  validates :subject_id, presence: true, uniqueness: true

  def self.search(keyword)
    return "パラメーターに検索語句を入力してください" unless keyword
    Subject.where("title LIKE ?", "%#{keyword}%")
  end
end