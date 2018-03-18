env = ENV["RACK_ENV"] || "development"

config = ERB.new File.new("config/database.yml").read
db_config = YAML::load(config)[env]

ActiveRecord::Base.establish_connection(db_config)
ActiveRecord::Base.logger = Logger.new(STDOUT) if env == "development"
