class ShowProduct
  def initialize(currency_converter:)
    @currency_converter = currency_converter
  end

  def call(id:, currency: 'usd')
    product = Product.not_deleted.find(id)

    # update_counters uses a SQL update statement to directly update the view count
    # so should be accurate still for writes that are concurrent/waiting for lock
    Product.update_counters(product.id, view_count: 1)

    product.view_count += 1 # To account for this view

    converted_price_in_cents = @currency_converter.convert(to: currency, usd_amount: product.price)

    ProductPriceFormatter.format(product: product, converted_price: converted_price_in_cents)
  end
end