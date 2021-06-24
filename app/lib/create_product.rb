class CreateProduct
  def call(price:, name:, description:)
    price_in_cents = (price * 100).to_i
    Product.create!(price: price_in_cents, 
                    name: name, 
                    description: description)
  end
end