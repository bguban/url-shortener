class UrlFollower
  UPDATE_CACHE_KEY = 'ufuck'.freeze
  FLUSH_IN = 30.seconds.freeze
  RUN_JOB_KEY = 'ufrj'.freeze


  def initialize(slug)
    @slug = slug
  end

  def call
    return unless url

    increment_counters

    url.target
  end

  private

  def url
    @url ||= Url.find_by(slug: @slug)
  end

  def increment_counters
    run_job = Rails.cache.redis.with do |c|
      c.pipelined do |p|
        p.incr(Url.redirects_count_cache_key(url.id)) # TODO: think about expiring the counters
        p.sadd(UPDATE_CACHE_KEY, url.id)
        p.set(RUN_JOB_KEY, '1', nx: true, ex: FLUSH_IN)
      end
    end.last
    UrlFollowerFlushJob.perform_in(FLUSH_IN + 5.seconds) if run_job
  end
end