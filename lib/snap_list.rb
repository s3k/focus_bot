require 'dotenv/load'
require 'telegram/bot'

require "pp"
require "snap_list/version"
require "snap_list/client"

module SnapList
  def self.run
    SnapList::Client.new(token: ENV["TG_TOKEN"]).call
  end
end
