class UrlDetailsSerializer
  def initialize(url)
    @url = url
  end

  def as_json
    @url.as_json.merge("redirects_count" => redirects_count)
  end

  private

  def redirects_count
    @url.redirects_count + @url.cached_redirects_count
  end
end
