class ProductPriceFormatter
  def self.format(product:, converted_price:)
    product.price = converted_price

    product
  end
end