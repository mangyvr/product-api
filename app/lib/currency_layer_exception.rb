class CurrencyLayerException < StandardError
  def initialize(msg="Error connecting to CurrencyLayer")
    super
  end
end