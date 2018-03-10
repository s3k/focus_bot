require "pp"
require "yaml"
require 'dotenv/load'
require 'telegram/bot'
require "active_record"

require "initializers/active_record_connection.rb"
require "snap_list/version"
require "snap_list/handler"
require "snap_list/client"

Dir[File.join(__dir__, "/model/**/*.rb")].each do |file|
  require file
end

module SnapList
  def self.run
    SnapList::Client.new(token: ENV["TG_TOKEN"]).call
  end
end
