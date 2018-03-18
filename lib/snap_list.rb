require "pp"
require "yaml"
require "erb"
require "dotenv/load"
require "telegram/bot"
require "active_record"

require "initializers/active_record_connection.rb"
require "snap_list/version"

require "snap_list/router"
require "snap_list/handler"
require "snap_list/client"


Dir[File.join(__dir__, "/../app/**/*.rb")].sort.each do |file|
  require file
end

module SnapList
  def self.run
    SnapList::Client.new(token: ENV["TG_TOKEN"]).call
  end
end
