# Fluent::Plugin::Riemann

`fluent-plugin-riemann` is a [fluentd](http://fluentd.org/ "Fluentd") output plugin that allows you to forward logs collected with fluentd to [riemann](http://riemann.io "Riemann").

## Installation

Add this line to your application's Gemfile:

    gem 'fluent-plugin-riemann'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluent-plugin-riemann

## Usage

    <match riemann.**>
      type riemann
      host localhost
      port 5555
      timeout 5
      protocol tcp
      service test log messages
      fields message:description,level:state,metric
      types metric:float
      flush_interval 10s
    </match>

## Contributing

1. Fork it ( http://github.com/wkf/fluent-plugin-riemann/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
