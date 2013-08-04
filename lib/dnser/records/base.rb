module DNSer
  class BaseRecord < DNSer::Record
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
          raise DNSer::Record::EmptyValue.new(name), 'Content must be defined'
      end

      @name = name.to_s.upcase.to_sym
      @value = value
      params = {ttl: domain.ttl}.merge(params)

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
      content = if type == :TXT
        '"' + @value.to_s + '"'
      else
        @value
      end

      if @priority_val == 0
        content
      else
        "#{@priority_val} #{content}"
      end
    end

    def ttl v
      @ttl_val = v
    end
  end
end
