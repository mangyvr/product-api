class UnsupportedCurrencyException < StandardError
  def initialize(msg="Unsupported currency")
    super
  end
end