require 'json'
require 'net/http'
require 'btce'

def get_bitcurex_ticker()
  uri = URI('https://pln.bitcurex.com/data/ticker.json')
  respo = Net::HTTP.get(uri)
  JSON.parse(respo.strip)
end

def get_btce_ticker(type)
  Btce::Ticker.new type
end


def get_market_stats()
  btce_btcltc_ticker = get_btce_ticker("ltc_btc")
  btce_ltcusd_ticker = get_btce_ticker("ltc_usd")
  bitcurex_ticker    = get_bitcurex_ticker

  items = [
      { label: "LTC/BTC - A", value: btce_btcltc_ticker.ask.to_s },
      { label: "LTC/BTC - B", value: btce_btcltc_ticker.bid.to_s },
      { label: "LTC/USD - A", value: "%.5f" % btce_ltcusd_ticker.ask },
      { label: "LTC/USD - B", value: "%.5f" % btce_ltcusd_ticker.bid },

      { label: "BTC/PLN - A", value: "%.2f" % bitcurex_ticker['buy'] },
      { label: "BTC/PLN - B", value: "%.2f" % bitcurex_ticker['sell'] }
  ]

  items
end

SCHEDULER.every '10s' do
   send_event("market", {items: get_market_stats})
end