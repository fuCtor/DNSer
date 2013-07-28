module DNS
  class Record
    attr_writer :host
    attr_reader :domain

    def initialize domain, host, params = {}
      unless host.is_a? Symbol
        @host = host.dup
      else
        @host = host
      end

      @domain = domain
    end

    def host
      collapse_domain @host.to_s
    end

    def full_host
      short_host = host
      if short_host == '@'
        domain.name
      else
        [host, domain.name].join('.')
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
  end
end

Dir.glob(::File.expand_path('../records/*.rb', __FILE__)).each{|file| require file }