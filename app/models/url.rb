class Url < ApplicationRecord
  validates :slug, :url, presence: true
  validates :slug, uniqueness: true
  # TODO: validate url
end
