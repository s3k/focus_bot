module SnapList
  class Client
    attr_accessor :token

    def initialize(opt={})
      @token = opt[:token]
    end

    def call
      bot_listen!
    end

    private

    def bot_listen!
      Telegram::Bot::Client.run(@token, logger: Logger.new($stderr)) do |bot|
        bot.listen do |message|
          resp = Struct.new(:bot, :message).new(bot, message)
          event_handler(resp)
        end
      end
    end

    def event_handler(resp)
      case resp.message
      when Telegram::Bot::Types::Message
        handle(resp, :command)
        handle(resp, :context)

      when Telegram::Bot::Types::CallbackQuery
        handle(resp, :callback)

      end
    end

    def handle(resp, type)
      if resp.message.is_a? Telegram::Bot::Types::CallbackQuery
        cmd = resp.message.data
      else
        cmd = resp.message.text
      end

      return nil unless routes[type.to_s]

      if type == :context
        model = config["mapper"]["model"]
        user_id = config["mapper"]["user_id"]
        command = config["mapper"]["command"]
        opt = { user_id => resp.message.from.id }

        cmd = model.constantize.find_by(opt)&.send(command)
      end

      routes[type.to_s].each do |binding, service|
        if cmd == binding
          name, method = service.split("#")
          name.constantize.new(resp).send(method)
        end
      end
    end

    def routes
      @routes ||= YAML.load_file("app/routes.yml")
    end

    def config
      @config ||= YAML.load_file("config/framework.yml")
    end
  end
end
