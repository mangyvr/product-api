class CurrencyConverter
  SUPPORTED_CURRENCIES = ['usd', 'cad', 'gbp', 'eur'].freeze

  def initialize(rates_fetcher:)
    @rates_fetcher = rates_fetcher
  end

  def convert(to:, usd_amount:)
    lowercase_to = to.downcase

    if !SUPPORTED_CURRENCIES.include?(lowercase_to)
      raise UnsupportedCurrencyException.new("#{lowercase_to} is not a supported currency.")
    end

    return usd_amount if lowercase_to == 'usd'

    @rates_fetcher.send("usd_to_#{lowercase_to}_rate".intern) * usd_amount
  end
end