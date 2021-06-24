class Api::V1::ProductsController < ApplicationController
  def show
    begin
      product = ShowProduct.new.call(id: params[:id])

      render json: product, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      head :not_found
    end
  end

  def destroy
    begin
      DestroyProduct.new.call(id: params[:id])

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

      product = CreateProduct.new.call(price: params[:price], 
                                            name: params[:name], 
                                            description: params[:description])

      head :created, location: api_v1_product_url(product)
    rescue ActiveRecord::RecordInvalid => e
      render json: {message: e}
    end
  
  end

  def most_viewed
    if params[:limit] && params[:limit] < 0
      return render json: {message: 'Limit must be positive'}, status: :bad_request
    end

    products = MostViewedProducts.new.call(limit: params[:limit])

    render json: products, status: :ok
  end
end
