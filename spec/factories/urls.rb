FactoryBot.define do
  factory :url do
    sequence(:slug) { |n| "slug#{n}" }
    target { "https://example.com" }
  end
end
