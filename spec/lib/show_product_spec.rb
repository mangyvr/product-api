require 'rails_helper'

RSpec.describe ShowProduct do
  let!(:product) { create(:product)}
  let(:converter) { instance_double("CurrencyConverter") }
  let!(:show_product) { ShowProduct.new(currency_converter: converter) }
  let(:converted_price) { 1234 }

  before(:each) do
    expect(converter).to receive(:convert).and_return(converted_price)
  end

  context 'show product' do
    it 'returns the correct product with correct view count and converted price' do
      returned_product = show_product.call(id: product.id)
      expect(returned_product.id).to eq(product.id)
      expect(returned_product.view_count).to eq(product.view_count + 1)
      expect(returned_product.price).to eq(converted_price)
    end

    it 'actually increments the view_count in the db' do
      show_product.call(id: product.id)
      retrieved_product = Product.find(product.id)
      expect(retrieved_product.view_count).to eq(product.view_count + 1)
    end
  end
end