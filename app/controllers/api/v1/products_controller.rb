class Api::V1::ProductsController < ApplicationController
  def show
    begin
      product = Product.not_deleted.find(params[:id])

      # update_counters uses a SQL update statement to directly update the view count
      # so should be accurate still for writes that are concurrent/waiting for lock
      Product.update_counters(product.id, view_count: 1)
      render json: product, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      head :not_found
    end
  end

  def destroy
    begin
      product = Product.not_deleted.find(params[:id])
      product.update!(deleted_at: Time.zone.now)
      head :no_content
    rescue ActiveRecord::RecordNotFound => e
      head :not_found
    end
  end

  def create
    begin
      if params[:price].nil?
        return render json: {message: 'Validation failed: Price is required.'}, status: :bad_request
      end

      price_in_cents = (params[:price] * 100).to_i
      product = Product.create!(price: price_in_cents, 
                                name: params[:name], 
                                description: params[:description])
      head :created, location: api_v1_product_url(product)
    rescue ActiveRecord::RecordInvalid => e
      render json: {message: e}
    end
  
  end

  def most_viewed
    if params[limit] && params_limit < 0
      return render json: {message: 'Limit must be positive'}, status: :bad_request
    end

    max_num_products = params[limit] || 5
    products = Product.not_deleted
                      .with_views
                      .order(view_count: :desc)
                      .limit(max_num_products)

    render json: products, status: :ok
  end
end
