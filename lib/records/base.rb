module DNS
  class BaseRecord < DNS::Record
    attr :ttl_val
    attr :value
    attr_reader :name

    def initialize domain, name, host, value, params = {}, &block

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
