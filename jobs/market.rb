require 'json'
require 'net/http'
require 'btce'
require_relative '../lib/config.rb'

BITCUREX_TICKER_URL = 'https://pln.bitcurex.com/data/ticker.json'
CONFIG = load_config unless defined?(CONFIG)

def get_bitcurex_ticker
  uri = URI(BITCUREX_TICKER_URL)
  req = Net::HTTP::Get.new(uri.request_uri)
  Net::HTTP.start(uri.host, uri.port,  :use_ssl =>true, :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |https|
    response = https.request(req)
    return JSON.parse(response.body.strip)
  end
end

# @param [String] type
def get_btce_ticker(type)
  Btce::Ticker.new type
end


def get_market_stats
  items = []

  btce_btcltc_ticker = nil
  if CONFIG['market']['show_btce'] || CONFIG['market']['show_ltc_to_pln']
    btce_btcltc_ticker = get_btce_ticker('ltc_btc')
    btce_ltcusd_ticker = get_btce_ticker('ltc_usd')

    #btc-e ticker stats
    items << { label: 'LTC/BTC - A', value: '%.5f' % btce_btcltc_ticker.ask }
    items << { label: 'LTC/BTC - B', value: '%.5f' % btce_btcltc_ticker.bid }
    items << { label: 'LTC/USD - A', value: '%.5f' % btce_ltcusd_ticker.ask }
    items << { label: 'LTC/USD - B', value: '%.5f' % btce_ltcusd_ticker.bid }

  end

  bitcurex_ticker = nil
  if CONFIG['market']['show_bitcurex'] || CONFIG['market']['show_ltc_to_pln']
    bitcurex_ticker    = get_bitcurex_ticker

    #bitcurex btc/pln
    items << { label: 'BTC/PLN - A', value: '%.2f' % bitcurex_ticker['buy'] }
    items << { label: 'BTC/PLN - B', value: '%.2f' % bitcurex_ticker['sell'] }
  end

  if CONFIG['market']['show_ltc_to_pln'] && !bitcurex_ticker.nil? && !btce_btcltc_ticker.nil?
    items << { label: 'LTC/PLN ', value: '%.4f' % (btce_btcltc_ticker.ask * bitcurex_ticker['sell']) }
  end

  items
end

if !CONFIG['market'].nil? && CONFIG['market']['enabled'] == true
  SCHEDULER.every '10s' do
    send_event('market', {items: get_market_stats})
  end
else
  puts 'Skipping market job - market disabled'
end