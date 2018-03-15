module SnapList
  class Client
    attr_accessor :token

    def initialize(opt={})
      @token = opt[:token]

      @command = load_config("command")
      @context = load_config("context")
      @callback = load_config("callback")
    end

    def call
      bot_listen!
    end

    private

    def event_handler(resp)
      case resp.message
      when Telegram::Bot::Types::Message
        handle(resp, @command)
        handle(resp, @context)

      when Telegram::Bot::Types::CallbackQuery
        handle(resp, @callback)

      end
    end

    def handle(resp, handler)
      if resp.message.is_a? Telegram::Bot::Types::CallbackQuery
        cmd = resp.message.data
      else
        cmd = resp.message.text
      end

      return nil unless handler["bind"]

      if handler["context"]
        ctx = handler["context"]
        model = ctx["model"]
        user_id = ctx["user_id"]
        command = ctx["command"]
        opt = { user_id => resp.message.from.id }

        cmd = model.constantize.find_by(opt)&.send(command)
      end

      handler["bind"].each do |binding, service|
        if cmd == binding
          name, method = service.split("#")
          name.constantize.new(resp).send(method)
        end
      end
    end

    def load_config(name)
      YAML.load_file("app/handler/#{name}.yml")
    end

    def bot_listen!
      Telegram::Bot::Client.run(@token, logger: Logger.new($stderr)) do |bot|
        bot.listen do |message|
          resp = Struct.new(:bot, :message).new(bot, message)
          event_handler(resp)
        end
      end
    end
  end
end
