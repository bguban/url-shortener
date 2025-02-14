class Url < ApplicationRecord
  validates :target, presence: true,
            format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: "must be a valid URL" }
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[\w\=]*\z/, message: "must be URL safe" },
            exclusion: { in: %w[api], message: "%{value} is reserved." }

  before_validation :populate_slug, unless: -> { slug }, on: :create

  def self.redirects_count_cache_key(id)
    "u/#{id}"
  end

  def cached_redirects_count
    Rails.cache.redis.with { |c| c.get(self.class.redirects_count_cache_key(id)) }.to_i
  end

  private

  def populate_slug
    loop do
      counter = Rails.cache.redis.with { |c| c.incr(:url_slug_counter) }.to_i
      self.slug = Base64.urlsafe_encode64([ counter ].pack("Q").gsub(/\x00+\z/, "")).gsub("=", "")
      break unless Url.find_by(slug: slug)
    end
  end
end
