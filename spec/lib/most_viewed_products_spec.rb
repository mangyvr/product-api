require 'rails_helper'

RSpec.describe MostViewedProducts do  
  let!(:product1) { create(:product, view_count: 5)}
  let!(:product2) { create(:product, view_count: 4)}
  let!(:product3) { create(:product, view_count: 3)}
  let(:converter) { instance_double("CurrencyConverter") }
  let!(:most_viewed_products) { MostViewedProducts.new(currency_converter: converter) }
  let(:converted_price) { 1234 }

  context 'most viewed products' do
    it 'returns a collection of products ordered by view count' do
      limit = 5
      expect(converter).to receive(:convert).exactly(3).times.and_return(converted_price)

      products = most_viewed_products.call(limit: limit, currency: 'usd')

      expect(products.first.id).to eq(product1.id)
      expect(products.second.id).to eq(product2.id)
      expect(products.third.id).to eq(product3.id)
    end

    it 'respects the limit passed in' do
      limit = 1
      expect(converter).to receive(:convert).once.and_return(converted_price)

      products = most_viewed_products.call(limit: limit, currency: 'usd')

      expect(products.first.id).to eq(product1.id)
      expect(products.length).to eq(limit)
    end
  end
end