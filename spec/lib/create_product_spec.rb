require 'rails_helper'

RSpec.describe CreateProduct do
  context 'create product' do
    it 'creates a new product successfully with correct values' do
      price = 1234
      name = 'test product'
      description = 'some desc'

      before_count = Product.count
      CreateProduct.new.call(price: price, name: name, description: description )
      after_count = Product.count
      
      last_product = Product.last

      expect(after_count).to eq(before_count + 1)
      expect(last_product.name).to eq(name)
      expect(last_product.price).to eq(price)
      expect(last_product.description).to eq(description)
    end
  end
end