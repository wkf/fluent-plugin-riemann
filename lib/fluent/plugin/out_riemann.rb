require 'riemann/client'

class Fluent::RiemannOutput < Fluent::BufferedOutput
  Fluent::Plugin.register_output('riemann', self)

  config_param :host, :string, :default => 'localhost'
  config_param :post, :integer, :default => 5555
  config_param :timeout, :integer, :default => 5
  config_param :protocol, :string, :default => 'tcp'
  config_param :include_service_key, :bool, :default => true

  include Fluent::SetTagKeyMixin
  config_set_default :include_tag_key, true

  include Fluent::SetTimeKeyMixin
  config_set_default :include_time_key, true

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

  def write(chunk)
    chunk.msgpack_each do |tag, time, record|
      record.merge!({@tag_key => tag}) if @include_tag_key
      record.merge!({@time_key => time}) if @include_time_key
      record.merge!({@service_key => tag}) if @include_service_key

      client << record
    end
  end
end
