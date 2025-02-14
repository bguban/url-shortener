class UrlFollowerFlushJob
  include Sidekiq::Job

  def perform
    url_ids = Rails.cache.redis.with { |c| c.smembers(UrlFollower::UPDATE_CACHE_KEY) } # TODO: use SSCAN

    url_ids.each_slice(1000) do |url_ids_batch|
      Rails.cache.redis.with { |c| c.srem(UrlFollower::UPDATE_CACHE_KEY, url_ids_batch) }
      counters = Rails.cache.redis.with { |c| c.mget(url_ids_batch.map { |id| Url.redirects_count_cache_key(id) }) }

      url_ids_batch.zip(counters).each do |id, redirects_count|
        Url.where(id: id).update_all("redirects_count = redirects_count + #{redirects_count}")
        Rails.cache.redis.with { |c| c.decrby(Url.redirects_count_cache_key(id), redirects_count) }
      end
    end
  end
end
