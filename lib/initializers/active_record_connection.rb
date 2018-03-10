env = ENV["RACK_ENV"] || "development"

db_config = YAML::load(File.open('config/database.yml'))[env]

ActiveRecord::Base.establish_connection(db_config)
ActiveRecord::Base.logger = Logger.new(STDOUT) if env == "development"
