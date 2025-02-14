require 'rails_helper'

RSpec.describe UrlFollower, type: :service do
  let(:url) { create(:url) }
  subject(:service) { UrlFollower.new(url.slug) }

  it 'returns the url and increments the counters and schedules the flush' do
    expect do
      expect(service.call).to eq(url.target)
    end.to change { url.cached_redirects_count }.by(1)
       .and change { UrlFollowerFlushJob.jobs.size }.by(1)

    # doesn't schedule the next flush again
    expect do
      UrlFollower.new(url.slug)
    end.not_to change { UrlFollowerFlushJob.jobs.size }
  end
end
