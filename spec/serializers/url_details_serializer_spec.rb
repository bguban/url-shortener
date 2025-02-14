require 'rails_helper'

RSpec.describe UrlDetailsSerializer, type: :serializer do
  describe '#redirects_count' do
    let(:url) { create(:url, redirects_count: 2) }

    before do
      UrlFollower.new(url.slug).call # follow the url
    end

    it 'uses both the count in the DB and in redis' do
      expect(UrlDetailsSerializer.new(url).as_json).to include('redirects_count' => 3)
    end
  end
end
