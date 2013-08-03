module DNSer
  class Record
    attr_writer :host
    attr_reader :domain

    class Unknown < RuntimeError
      attr_reader :name
      attr_reader :args
      def initialize name, args
        @name = name
        @args = args
      end
    end

    class EmptyValue < RuntimeError
      attr_reader :record
      attr_reader :field
      def initialize record
        @record = record
      end
    end


    def initialize domain, host, params = {}

      ttl domain.ttl
      priority 0 unless @priority_val

      unless host.is_a? Symbol
        @host = host.dup
      else
        @host = host
      end

      @domain = domain
    end

    def ttl(value)
      @ttl = value
    end

    def priority(value)
      @priority_val = value
    end

    alias_method :prio, :priority

    def host
      collapse_domain @host.to_s
    end

    def full_host
      short_host = host
      if short_host == '@'
        domain.name
      else
        [short_host, domain.name].join('.')
      end
    end

    def type
      raise NotImplementedError
    end

    def value
      raise NotImplementedError
    end

    def comment(v = nil)
      @comment = v if v
      @comment || ''
    end


    protected
    def collapse_domain name
      name = name.dup
      return name if name == '@'
      return name unless name.index('.')

      name = name + '.' unless name.end_with?('.')
      name.gsub!( domain.name.dup, '')
      name.chop! if name.end_with?('.')

      if name.empty?
        '@'
      else
        name
      end
    end

    def canonical_host target_host

      case host
        when DNSer::Record
          target_host = target_host.full_host.to_s
        when IPAddr
          target_host = target_host.to_s
        else

          ip = IPAddr.new target_host rescue nil
          return target_host.to_s if ip

          target_host = target_host.to_s
          target_host = target_host + '.' unless target_host.end_with? '.'
      end

      target_host

    end

  end
end

Dir.glob(::File.expand_path('../records/*.rb', __FILE__)).each{|file| require file }