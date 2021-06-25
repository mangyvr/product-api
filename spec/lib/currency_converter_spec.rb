require 'rails_helper'

RSpec.describe CurrencyConverter do
  context 'currency conversion' do
    let(:rates_fetcher) { instance_double("RatesFetcher") }
    let!(:converter) { CurrencyConverter.new(rates_fetcher: rates_fetcher) }

    it 'raises UnsupportedCurrencyException for unsupported currency' do
      expect{converter.convert(to: 'xyz', usd_amount: 1234)}.to raise_error(UnsupportedCurrencyException)
    end

    it 'calls the correct method for a supported currency and returns the correct amount' do
      usd_amount = 1234
      fake_usd_to_cad_rate = 0.1234
      
      expect(rates_fetcher).to receive(:usd_to_cad_rate).and_return(fake_usd_to_cad_rate)
      converted_amount = converter.convert(to: 'cad', usd_amount: usd_amount)
      expected_amount = usd_amount * fake_usd_to_cad_rate

      expect(converted_amount).to eq(expected_amount)
    end
  end
end