require 'rails_helper'

RSpec.describe "/urls", type: :request do
  let(:valid_attributes) { attributes_for(:url) }

  let(:invalid_attributes) { attributes_for(:url, target: 'bla') }

  let(:valid_headers) { {} }

  describe 'GET /:slug' do
    let(:url) { create(:url) }

    context 'when correct slug passed' do
      it 'follows the redirect' do
        get follows_url(slug: url.slug)
        expect(response).to redirect_to(url.target)
      end
    end

    context 'when a wrong slug passed' do
      it 'returns 404' do
        get follows_url(slug: 'bla')
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "GET /index" do
    let!(:urls) { create_pair(:url) }

    it "renders a successful response" do
      get urls_url, headers: valid_headers, as: :json
      expect(response).to be_successful
      expect(parsed).to eq({ urls:  urls }.as_json)
    end
  end

  describe "GET /show" do
    let(:url) { create(:url) }

    it "renders a successful response" do
      get url_url(url), as: :json
      expect(response).to be_successful
      expect(parsed).to eq({ url: url }.as_json)
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Url" do
        expect do
          post urls_url, params: { url: valid_attributes }, headers: valid_headers, as: :json
        end.to change(Url, :count).by(1)
        expect(Url.last).to have_attributes(valid_attributes)
      end

      it 'auto-generates slug if not passed' do
        expect do
          post urls_url, params: { url: valid_attributes.except(:slug) }, headers: valid_headers, as: :json
        end.to change(Url, :count).by(1)
        expect(Url.last).to have_attributes(valid_attributes.except(:slug))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Url and returns errors" do
        expect do
          post urls_url, params: { url: invalid_attributes }, as: :json
        end.not_to change(Url, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(parsed['errors']).to include({ 'target' => [ "must be a valid URL" ] })
      end
    end
  end

  describe "PATCH /update" do
    let(:url) { create(:url) }
    context "with valid parameters" do
      let(:new_attributes) { { slug: 'bla' } }

      it "updates the requested url" do
        patch url_url(url), params: { url: new_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        url.reload
        expect(parsed).to eq({ url: url }.as_json)
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the url" do
        expect do
          patch url_url(url), params: { url: invalid_attributes }, headers: valid_headers, as: :json
        end.not_to change { url.reload }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(parsed['errors']).to include('target' => [ "must be a valid URL" ])
      end
    end
  end

  describe "DELETE /destroy" do
    let!(:url) { create(:url) }

    it "destroys the requested url" do
      expect do
        delete url_url(url), headers: valid_headers, as: :json
      end.to change(Url, :count).by(-1)
    end
  end
end
