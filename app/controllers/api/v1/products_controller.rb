class Api::V1::ProductsController < ApplicationController
  def show
    begin
      product = Product.not_deleted.find(params[:id])
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
      return render json: {message: 'Price is required.'}, status: :bad_request if params[:price].nil?

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

  end
end
