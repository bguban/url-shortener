class UrlFollower
  def initialize(slug)
    @slug = slug
  end

  def call
    url = Url.find_by(slug: @slug)
    return unless  url

    Rails.cache.redis.with { |c| c.incr(Url.redirects_count_cache_key(url.id)) }
    url.target
  end
end