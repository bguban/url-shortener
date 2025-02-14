class Url < ApplicationRecord
  validates :target, presence: true,
            format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: 'must be a valid URL'}
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[\w\=]*\z/, message: 'must be URL safe' },
            exclusion: { in: %w(api), message: "%{value} is reserved." }

  def self.redirects_count_cache_key(id)
    "u/#{id}"
  end

  def cached_redirects_count
    Rails.cache.redis.with { |c| c.get(self.class.redirects_count_cache_key(id)) }.to_i
  end
end
