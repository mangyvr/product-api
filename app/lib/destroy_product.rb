class DestroyProduct
  def call(id:)
    product = Product.not_deleted.find(id)
    product.update!(deleted_at: Time.zone.now)
  end
end