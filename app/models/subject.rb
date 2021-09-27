class Subject < ApplicationRecord
  has_many :lectures, dependent: :destroy
  belongs_to :teacher
  validates :subject_id, presence: true, uniqueness: true
  validates :teacher_id, presence: true

  #keywordリクエストによる科目名検索（あいまい検索対応）
  def self.title_search(keyword)
    Subject.where("title LIKE ?", "%#{keyword}%")
  end
end