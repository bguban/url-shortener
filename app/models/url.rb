class Url < ApplicationRecord
  validates :target, presence: true,
            format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: 'must be a valid URL'}
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[\w\=]*\z/, message: 'must be URL safe' },
            exclusion: { in: %w(api), message: "%{value} is reserved." }
end
