module ApiHelpers
  def parsed
    @parsed ||= JSON.parse(response.body)
  end
end
