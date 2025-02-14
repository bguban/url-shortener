class UrlDetailsSerializer
  def initialize(url)
    @url = url
  end

  def as_json
    @url.as_json.merge('redirects_count' => redirect_counters)
  end

  private

  def redirect_counters
    @url.redirects_count + (Rails.cache.redis.with { |c| c.get(Url.redirects_count_cache_key(@url.id)).to_i })
  end
end