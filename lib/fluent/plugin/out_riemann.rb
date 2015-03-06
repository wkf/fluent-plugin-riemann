require 'riemann/client'

class Fluent::RiemannOutput < Fluent::BufferedOutput
  class ConnectionFailure < StandardError; end
  Fluent::Plugin.register_output('riemann', self)

  config_param :host,     :string,  :default => '127.0.0.1'
  config_param :port,     :integer, :default => 5555
  config_param :timeout,  :integer, :default => 5
  config_param :ttl,      :integer, :default => 90
  config_param :protocol, :string,  :default => 'tcp'
  config_param :fields,   :hash,    :default => {}
  config_param :fields_from_metric, :string, :default => nil
  config_param :service,  :string,  :default => 'default'

  def initialize
    super
  end

  def configure(c)
    super
  end

  def start
    super
  end

  def shutdown
    super
  end

  def client
    @_client ||= Riemann::Client.new :host => @host, :port => @port, :timeout => @timeout
    @protocol == 'tcp' ? @_client.tcp : @_client.udp
  end

  def format(tag, time, record)
    [tag, time, record].to_msgpack
  end

  def remap(data)
    if data.is_a? String
      if data =~ /^\d+\.\d+$/
        data = data.to_f
      elsif data =~ /^\d+$/
        data = data.to_i
      else
        data = nil
      end
    end
    data
  end

  def write(chunk)
    chunk.msgpack_each do |tag, time, record|
        event = {
          :time    => time,
          :tag     => tag,
          :service => @service,
          :message => record["message"],
          :path    => record["path"]
        }

        retries = 0
        begin
          client << event
        rescue Exception => e
          if retries < 2
            retries += 1
            log.warn "Could not push metrics to Riemann, resetting connection and trying again. #{e.message}"
            @_client = nil
            sleep 2**retries
            retry
          end
          raise ConnectionFailure, "Could not push metrics to Riemann after #{retries} retries. #{e.message}"
        end
    end
  end
end
