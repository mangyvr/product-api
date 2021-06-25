class CurrencyLayerRatesFetcher < RatesFetcher
  def initialize
    get_quotes_from_currency_layer
  end

  def usd_to_cad_rate
    @quotes["USDCAD"]
  end

  def usd_to_eur_rate
    @quotes["USDEUR"]
  end

  def usd_to_gbp_rate
    @quotes["USDGBP"]
  end

  private

  def get_quotes_from_currency_layer
    response = Faraday.get('http://apilayer.net/api/live',
                          {access_key: ENV['CURRENCYLAYER_API_KEY'],
                           currencies: 'CAD,EUR,GBP',
                           source: 'USD'})

    raise CurrencyLayerException.new("Unable to fetch rates from Currency Layer.") if response.status != 200

    @quotes = JSON.parse(response.body)['quotes']
  end

end