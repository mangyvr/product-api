require 'rails_helper'
require 'helpers/currency_layer_helpers'

RSpec.configure do |c|
  c.include CurrencyLayerHelpers
end

RSpec.describe CurrencyLayerRatesFetcher do
  context 'rates' do
    before(:each) do
      faraday_response = instance_double(Faraday::Response, body: success_body, status: 200)
      allow(Faraday).to receive(:get) { faraday_response }
    end

    let(:quotes) { JSON.parse(success_body)['quotes'] }
    let!(:rate_fetcher) { CurrencyLayerRatesFetcher.new }

    it 'should return the correct usd to cad rate' do
      expect(rate_fetcher.usd_to_cad_rate).to eq(quotes['USDCAD'])
    end

    it 'should return the correct usd to gbp rate' do
      expect(rate_fetcher.usd_to_gbp_rate).to eq(quotes['USDGBP'])
    end

    it 'should return the correct usd to eur rate' do
      expect(rate_fetcher.usd_to_eur_rate).to eq(quotes['USDEUR'])
    end
  end
end