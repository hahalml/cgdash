require 'json'
require 'net/http'

CONFIG = load_config unless defined?(CONFIG)

def get_active_workers(response)
  active_workers = 0
  unless response['workers'].nil?
    response['workers'].each do |_, worker|
      if worker['alive'] == '1'
        active_workers += 1
      end
    end
  end
  active_workers
end

def get_hashrate(response)
  if response['total_hashrate'].nil?
    ''
  else
    hashrate = '%.3f' % (response['total_hashrate'].to_f / 1000.0)
    "#{hashrate} MH/s"
  end
end

def get_confirmed_rewards(response)
  if response['confirmed_rewards'].nil?
    0
  else
    '%.10f' % response['confirmed_rewards']
  end
end

def get_pool_data(url)
  uri = URI(url)
  req = Net::HTTP::Get.new(uri.request_uri)
  Net::HTTP.start(uri.host, uri.port, :use_ssl => true, :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |https|
    response = https.request(req)
    return JSON.parse(response.body.strip)
  end
end

def get_pool_items(url)
  response = get_pool_data(url)
  items = []
  items << {label: 'Rew.', value: get_confirmed_rewards(response)}
  items << {label: 'Hashrate', value: get_hashrate(response)}
  items << {label: 'Active workers', value: get_active_workers(response)}

  items
end


if CONFIG['pools']
  CONFIG['pools'].each do |name, url|
    SCHEDULER.every '30s', :first_in => 0 do
      send_event('pool_' + name, {items: get_pool_items(url)})
    end
  end


end
