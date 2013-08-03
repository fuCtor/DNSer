module DNS
  class BaseRecord < DNS::Record
    attr :ttl_val
    attr :value
    attr_reader :name

    def initialize domain, name, *args, &block

      params = {}
      params = args.pop if args.last.is_a? Hash

      host = domain.host
      value = nil

      case args.size
        when 2
          host = args[0]
          value = args[1]
        when 1
          value = args[0]
        else
          raise 'Content must be define'
      end

      @name = name.to_sym
      @value = value
      params = {ttl: domain.ttl_val}.merge(params)

      params.each do |key, value|
        self.send "#{key}", value if self.respond_to? key
      end

      super domain, host, params
      instance_eval &block  if block_given?
    end

    def type
      self.name
    end

    def value
      if @value.to_s.include?(' ')
        '"' + @value.to_s + '"'
      else
        @value
      end
    end

    def ttl v
      @ttl_val = v
    end
  end
end
