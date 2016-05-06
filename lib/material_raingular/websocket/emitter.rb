module MaterialRaingular
  module Websocket
    class Emitter
      class << self
        def [](channel)
          new(channel)
        end
        def redis() new.redis end
        def token(channel) new(channel).token end
        def publish(channel,action,data) new(channel).publish(action,data) end
      end
      def redis()
        @redis ||= Redis.new(WebsocketRails.config.redis_options.reject{|k,v| k.to_sym == :driver})
      end
      def token
        @token ||= redis.hget "websocket_rails.channel_tokens", channel
      end
      def publish(action,data)
        return unless token.present?
        redis.publish "websocket_rails.events", [action,{data: data,channel: channel, token: token}].to_json
      end
      def initialize(channel=nil)
        self.channel = channel
      end
      attr_accessor :channel

    end
  end
end
