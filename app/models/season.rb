class Season < ApplicationRecord
  has_many :posts, dependent: :restrict_with_error

  validates :name, presence: true
  validates :start_year, presence: true, uniqueness: true, numericality: { only_integer: true }

  scope :newest_first, -> { order(start_year: :desc) }

  def self.current
    newest_first.first
  end

  def previous
    Season.where("start_year < ?", start_year).order(start_year: :desc).first
  end

  def next
    Season.where("start_year > ?", start_year).order(:start_year).first
  end
end
