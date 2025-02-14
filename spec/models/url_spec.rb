require 'rails_helper'

RSpec.describe Url, type: :model do
  describe 'target validations' do
    let(:url) { build(:url) }

    it 'allows only url' do
      [ 'https://google.com?foo=bar&bar=baz#bla' ].each do |target|
        url.target = target
        expect(url).to be_valid
      end

      [ 'bla.com' ].each do |target|
        url.target = target
        expect(url).to be_invalid
      end
    end
  end

  describe 'slug validations' do
    let(:url) { build(:url) }

    it 'allows only url safe slugs not reserved slugs' do
      [ 'bla_=' ].each do |slug|
        url.slug = slug
        expect(url).to be_valid
      end

      [ 'foo/bar', 'api' ].each do |slug|
        url.slug = slug
        expect(url).to be_invalid
      end
    end
  end
end
