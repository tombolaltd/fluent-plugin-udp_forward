require 'fluent/input'
module Fluent
  class UDPForwardInput < Input

    Fluent::Plugin.register_input('udp_forward', self)
    require 'socket'

    config_param :port, :integer, :default => 5160
    config_param :bind, :string, :default => '0.0.0.0'
    config_param :tag_key, :string, :default => 'tag'
    config_param :message_key, :string, :default => 'data'

    def configure(conf)
      super
    end

    def multi_workers_ready?
      true
    end

    def start
      super

      $log.info("udp_forward listening on #{@bind}:#{@port}")

      @thread = Thread.new(Thread.current) do |parent|
        while (true)
          begin
            Socket.udp_server_loop(@bind, @port) do |msg, msg_src|
            tag, time, record = parse(msg)
            router.emit(tag, time, record)
          end
          rescue
            $log.error("unexpected error in udp_server_loop", :error=>$!.to_s)
            $log.error_backtrace
          end
        end
      end
    end

    def shutdown
      super
      @thread.kill
    end

    private 

      def parse(message)
        begin
          parsed = JSON.parse(message)
        rescue
          $log.warn("Parse error : #{message} \n #{$!.to_s}")
          parsed = {}
        end

        time = Engine.now
        tag = parsed[@tag_key]
        record = parsed[@message_key]

        if(tag.nil? || record.nil?)
          $log.warn("invalid message supplied: #{message}")
        end

        return [tag, time, record]
      end
  end
end
