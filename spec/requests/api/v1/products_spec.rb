require 'rails_helper'
require 'helpers/currency_layer_helpers'

RSpec.configure do |c|
  c.include CurrencyLayerHelpers
end

RSpec.describe "Api::V1::Products", type: :request do
  describe "POST /api/v1/products" do
    let(:name) { 'Test Product' }
    let(:price) { 1000 }
    let(:desc) { 'this is a test' }

    it 'successfully creates a product with given parameters' do
      before_count = Product.count

      post "/api/v1/products", params: {name: name, price: price, description: desc}

      last_product = Product.last

      after_count = Product.count

      expect(response).to have_http_status(:created)
      expect(after_count).to eq(before_count + 1)
      expect(response.headers['location']).to eq(api_v1_product_url(last_product))
      expect(last_product.name).to eq(name)
      expect(last_product.price).to eq(price)
      expect(last_product.description).to eq(desc)
    end

    it 'returns status 400 if price is missing' do
      post "/api/v1/products", params: {name: name, description: desc}

      expect(response).to have_http_status(:bad_request)
    end

    it 'returns status 400 if name is missing' do
      post "/api/v1/products", params: {price: price, description: desc}

      expect(response).to have_http_status(:bad_request)
    end
  end

  describe "DELETE /api/v1/products/:id" do
    let!(:test_product) { create(:product) }

    it 'soft deletes the product when a valid id is passed in' do
      delete "/api/v1/products/#{test_product.id}"
      reloaded_product = test_product.reload
      
      expect(response).to have_http_status(:no_content)
      expect(reloaded_product.deleted_at).not_to be_nil 
    end

    it 'returns not found for an invalid id' do
      invalid_id = Product.last.id + 1
      delete "/api/v1/products/#{invalid_id}"

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /api/v1/products/:id" do
    before(:each) do |test|
      faraday_response = instance_double(Faraday::Response, body: success_body, status: 200)
      allow(Faraday).to receive(:get) { faraday_response } unless test.metadata[:bad_status]
    end

    let(:quotes) { JSON.parse(success_body)['quotes'] }
    let!(:test_product) { create(:product) }

    def verify_prices(currency)
      get "/api/v1/products/#{test_product.id}?currency=#{currency}"

      parsed_response = JSON.parse(response.body)
      converted_price = (test_product.price * quotes["USD#{currency.upcase}"]).to_i

      expect(response).to have_http_status(:ok)
      expect(parsed_response['id']).to eq(test_product.id)
      expect(parsed_response['price']).to eq(converted_price)
    end

    it "displays the correct product with correct view count in usd" do
      get "/api/v1/products/#{test_product.id}"

      parsed_response = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(parsed_response['id']).to eq(test_product.id)
      expect(parsed_response['name']).to eq(test_product.name)
      expect(parsed_response['price']).to eq(test_product.price)
      expect(parsed_response['view_count']).to eq(test_product.view_count + 1)
    end

    it "display the correct product price in cad" do
      verify_prices('cad')
    end

    it "display the correct product price in gbp" do
      verify_prices('gbp')
    end

    it "display the correct product price in eur" do
      verify_prices('eur')
    end

    it "returns bad request for an unsupported currency" do
      get ("/api/v1/products/#{test_product.id}?currency=asdf")

      expect(response).to have_http_status(:bad_request)
    end

    it "returns not found for a soft deleted product" do
      delete "/api/v1/products/#{test_product.id}"
      get "/api/v1/products/#{test_product.id}"

      expect(response).to have_http_status(:not_found)
    end

    it "returns bad gateway if currency layer returns non-200 status", :bad_status do
      faraday_response = instance_double(Faraday::Response, status: 400)
      allow(Faraday).to receive(:get) { faraday_response }

      get "/api/v1/products/#{test_product.id}"

      expect(response).to have_http_status(:bad_gateway)
    end
  end

  describe "GET /api/v1/products/most_viewed" do
    let!(:product1) { create(:product, view_count: 5, price: 100)}
    let!(:product2) { create(:product, view_count: 4, price: 200)}
    let!(:product3) { create(:product, view_count: 3, price: 300)}
    let!(:product4) { create(:product, view_count: 0, price: 400)}
    let(:quotes) { JSON.parse(success_body)['quotes'] }

    before(:each) do |test|
      faraday_response = instance_double(Faraday::Response, body: success_body, status: 200)
      allow(Faraday).to receive(:get) { faraday_response } unless test.metadata[:bad_status]
    end

    def verify_prices(currency)
      get "/api/v1/products/most_viewed?currency=#{currency}"

      parsed_response = JSON.parse(response.body)
      exchange_rate = quotes["USD#{currency.upcase}"]

      expect(response).to have_http_status(:ok)
      expect(parsed_response.first['price']).to eq((product1.price * exchange_rate).to_i)
      expect(parsed_response.second['price']).to eq((product2.price * exchange_rate).to_i)
      expect(parsed_response.third['price']).to eq((product3.price * exchange_rate).to_i)
    end

    it 'returns products in order by view count, and does not display products with 0 views' do
      get '/api/v1/products/most_viewed'

      parsed_response = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(parsed_response.first['id']).to eq(product1.id)
      expect(parsed_response.second['id']).to eq(product2.id)
      expect(parsed_response.third['id']).to eq(product3.id)
      expect(parsed_response.length).to eq(3)
    end

    it 'respects limit' do
      limit = 1
      get "/api/v1/products/most_viewed?limit=#{limit}"

      parsed_response = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(parsed_response.first['id']).to eq(product1.id)
      expect(parsed_response.length).to eq(limit)
    end

    it 'returns the proper prices in cad' do
      verify_prices('cad');
    end

    it 'returns the proper prices in gbp' do
      verify_prices('gbp');
    end

    it 'returns the proper prices in eur' do
      verify_prices('eur');
    end

    it 'returns bad_request for an unsupported currency' do
      get "/api/v1/products/most_viewed?currency=asdf"

      expect(response).to have_http_status(:bad_request)
    end

    it "returns bad gateway if currency layer returns non-200 status", :bad_status do
      faraday_response = instance_double(Faraday::Response, status: 400)
      allow(Faraday).to receive(:get) { faraday_response }

      get "/api/v1/products/most_viewed"

      expect(response).to have_http_status(:bad_gateway)
    end
  end
end
