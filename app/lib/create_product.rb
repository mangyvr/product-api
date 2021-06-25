class CreateProduct
  def call(price:, name:, description:)
    Product.create!(price: price, 
                    name: name, 
                    description: description)
  end
end