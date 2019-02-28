require 'fluent/input'
module Fluent
  class UDPForwardInput < Fluent::Input
    Plugin.register_input('udp_forward', self)
    include DetachMultiProcessMixin
    require 'socket'
    require 'json'
    def initialize
      super
    end

    config_param :port, :integer, :default => 5161
    config_param :bind, :string, :default => '0.0.0.0'
    config_param :tag_key, :string, :default => 'tag'
    config_param :message_key, :string, :default => 'data'
    config_param :message_length_limit, :integer, :default => 4096

    def configure(conf)
      super
    end

    def start
     
      @udp_socket = UDPSocket.new
   
      detach_multi_process do
        super
           @udp_socket.bind(@bind, @port)
           $log.info "udp_forward listening on #{@bind}:#{@port}"
        @thread = Thread.new(&method(:run))
      end
    end

    def shutdown
      @udp_socket.close
      @thread.join
    end

    def run
       loop do
         text, sender =  @udp_socket.recvfrom(@message_length_limit)
         if text.length() == @message_length_limit
           $log.warn "Message length was #{text.length()} bytes, the same as the length limit: #{text}"
         end
         begin
           json_obj = JSON.parse(text)
         rescue
           $log.warn "Parse error : #{text} \n #{$!.to_s}" 
           json_obj = {}
         end
         time = Engine.now
         tag = json_obj[@tag_key] || "unknown"
         message = json_obj[@message_key]

         router.emit(tag, time, message)
       end
    rescue
      $log.error "unexpected error", :error=>$!.to_s
      $log.error_backtrace
    end
  end
end
