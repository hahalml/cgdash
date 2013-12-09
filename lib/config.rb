def load_config()

  puts "Loading config\n"
  config_dir = File.dirname(__FILE__) + "/../config"

  config_file = "#{config_dir}/config.yml"
  default_config_file = "#{config_dir}/config_default.yml"

  if File.exist? config_file
    config = YAML.load_file(config_file)
  else
    puts "Config file not found (config.yml), loading defaults\n"
    config = YAML.load_file(default_config_file)
  end

  config
end