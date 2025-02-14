require 'rails_helper'
RSpec.describe UrlFollowerFlushJob, type: :job do
  let(:url) { create(:url) }

  before { UrlFollower.new(url.slug).call }

  it 'flushes the counters into the DB' do
    expect { UrlFollowerFlushJob.drain }
      .to change { url.reload.redirects_count }.by(1)
      .and change { url.cached_redirects_count }.by(-1)
  end
end
