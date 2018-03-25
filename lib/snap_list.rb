require "dotenv/load"
require "telegraph"

Dir[File.join(__dir__, "/../app/**/*.rb")].sort.each do |file|
  require file
end

module SnapList
  def self.run
    Telegraph.run(ENV["TG_TOKEN"])
  end
end
