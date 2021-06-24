class MostViewedProducts
  def call(limit:)
    max_num_products = limit || 5
    Product.not_deleted
           .with_views
           .order(view_count: :desc)
           .limit(max_num_products)
  end
end