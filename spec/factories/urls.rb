FactoryBot.define do
  factory :url do
    sequence(:slug) { |n| "slug#{n}" }
    url { "https://example.com" }
  end
end
