module DNSer
  class SoaRecord < DNSer::Record
    def initialize domain, host, params = {}, &block

      [:port, :weight, :protocol, :service].each do |m|
        instance_variable_set("@#{m}".to_sym, nil)
        self.class.send :define_method, m, proc { |*args|
          instance_variable_set("@#{m}", args.first) unless args.empty?
          instance_variable_get("@#{m}")
        }
      end

      params = {weight: 0}.merge(params)

      params.each do |key, value|
        self.send key, value if  self.respond_to? key
      end

      super domain, host, params
      instance_eval &block  if block_given?

      # raise 'Email must be define' unless @email
    end

    def host
      first_part = [@service, @protocol].map {|i| i.start_with?('_') ? i : ('_' + i)} .join('.')
      [first_part, full_host].join '.'
    end

    def type
      :PTR
    end

    def value
      [@priority, @weight, @port, @value ].map { |i| i.is_a?(Record) ? i.full_host : i.to_s } .join(' ')
    end
  end
end
