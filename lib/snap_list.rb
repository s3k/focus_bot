require "pp"
require "yaml"
require 'dotenv/load'
require 'telegram/bot'
require "active_record"

require "initializers/active_record_connection.rb"
require "snap_list/version"

#require "snap_list/handler/base"
#require "snap_list/handler/callback"
#require "snap_list/handler/message"
#require "snap_list/handler/inline"
require "snap_list/handler"
require "snap_list/client"


Dir[File.join(__dir__, "/../app/model/**/*.rb")].each do |file|
  require file
end

Dir[File.join(__dir__, "/../app/service/**/*.rb")].each do |file|
  require file
end

module SnapList
  def self.run
    SnapList::Client.new(token: ENV["TG_TOKEN"]).call
  end
end
