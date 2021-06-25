class MostViewedProducts
  def initialize(currency_converter:)
    @currency_converter = currency_converter
  end

  def call(limit:, currency:)
    products = Product.not_deleted
                      .with_views
                      .order(view_count: :desc)
                      .limit(limit)
    
    products.map do |product|
      converted_price_in_cents = @currency_converter.convert(to: currency, usd_amount: product.price)
      ProductPriceFormatter.format(product: product, converted_price: converted_price_in_cents)
    end
  end
end