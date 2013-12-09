require 'json'
require 'net/http'

CONFIG = load_config unless defined?(CONFIG)

def get_active_workers(response)
  active_workers = 0
  response['workers'].each do |_, worker|
    if worker['alive'] == '1'
      active_workers += 1
    end
  end
  active_workers
end

def get_hashrate(response)
  hashrate = "%.3f" % (response['total_hashrate'].to_f / 1000.0)
  "#{hashrate} MH/s"
end

def get_confirmed_rewards(response)
  '%.10f' % response['confirmed_rewards']
end

def get_pool_data(url)
  response_str = Net::HTTP.get(URI(url))
  response = JSON.parse(response_str.strip)
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
