class ShowProduct
  def call(id:)
    product = Product.not_deleted.find(id)

    # update_counters uses a SQL update statement to directly update the view count
    # so should be accurate still for writes that are concurrent/waiting for lock
    Product.update_counters(product.id, view_count: 1)

    product
  end

end