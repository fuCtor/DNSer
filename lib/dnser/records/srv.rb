module DNSer
  class SrvRecord < DNSer::BaseRecord
    def initialize domain, *args, &block

      params = {}
      params = args.pop if args.last.is_a? Hash

      host = domain.host
      value = nil

      [:port, :weight, :protocol, :service].each do |m|
        instance_variable_set("@#{m}".to_sym, nil)
        self.class.send :define_method, m, proc { |*args|
          instance_variable_set("@#{m}", args.first) unless args.empty?
          instance_variable_get("@#{m}")
        }
      end

      params = {weight: 0, priority: 0, port: 0}.merge(params)

      params.each do |key, value|
        self.send key, value if  self.respond_to? key
      end

      super domain, :SRV, *args, &block

      raise DNSer::Record::EmptyValue.new(self), 'Service must be defined' unless @service
      raise DNSer::Record::EmptyValue.new(self), 'Protocol must be defined' unless @protocol
      raise DNSer::Record::EmptyValue.new(self), 'Port must be defined' if @port == 0
    end

    def host
      first_part = [@service, @protocol].map(&:to_s).map {|i| i.start_with?('_') ? i : ('_' + i)} .join('.')

      short_host = collapse_domain @host
      if(short_host == '@')
        [first_part, domain.name ]
      else
        [first_part, short_host, domain.name]
      end .join('.')

    end

    def value
      res = super.split(' ')
      case res.size
        when 1
          ['0', @weight, @port, res.first ]
        when 2
          [res.first, @weight, @port, res.last ]
      end .map(&:to_s).join(' ')
    end
  end
end
