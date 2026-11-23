class Post < ApplicationRecord
  belongs_to :season

  scope :published, -> { where("published_at <= ?", DateTime.now) }
  scope :unsent, -> { where(sent_at: nil) }

  has_one_attached :header_image
end
