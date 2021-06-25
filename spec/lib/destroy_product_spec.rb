require 'rails_helper'

RSpec.describe DestroyProduct do
  context 'destroy product' do
    it 'soft deletes a product' do
      product = create(:product)

      DestroyProduct.new.call(id: product.id)

      product.reload

      expect(product.deleted_at).not_to be_nil
    end
  end
end