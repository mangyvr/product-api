require 'rails_helper'

RSpec.describe Product, type: :model do
  describe('validations') do
    it 'should require presence of name' do
      product = build(:product, name: '')

      expect{ product.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should require presence of price' do
      product = build(:product, price: '')

      expect{ product.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
