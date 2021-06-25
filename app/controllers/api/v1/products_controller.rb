class Api::V1::ProductsController < ApplicationController
  def show
    begin
      rates_fetcher = CurrencyLayerRatesFetcher.new
      converter = CurrencyConverter.new(rates_fetcher: rates_fetcher)
      currency = params[:currency] || 'usd'
      
      product = ShowProduct.new(currency_converter: converter).call(id: params[:id], currency: currency)

      render json: product, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      head :not_found
    rescue CurrencyLayerException => e
      render json: {message: e}, status: :bad_gateway
    rescue UnsupportedCurrencyException => e
      render json: {message: e}, status: :bad_request
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
      render json: {message: e}, status: :bad_request
    end
  
  end

  def most_viewed
    if params[:limit] && params[:limit].to_i < 0
      return render json: {message: 'Limit must be positive'}, status: :bad_request
    end

    begin
      rates_fetcher = CurrencyLayerRatesFetcher.new
      converter = CurrencyConverter.new(rates_fetcher: rates_fetcher)
      currency = params[:currency] || 'usd'
      limit = params[:limit] || 5

      products = MostViewedProducts.new(currency_converter: converter).call(limit: limit, currency: currency)

      render json: products, status: :ok
    rescue CurrencyLayerException => e
      render json: {message: e}, status: :bad_gateway
    rescue UnsupportedCurrencyException => e
      render json: {message: e}, status: :bad_request
    end
  end
end
