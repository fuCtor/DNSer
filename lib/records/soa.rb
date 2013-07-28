module DNS
  class SoaRecord < DNS::Record
    def initialize domain, host, params = {}, &block

      [:ttl, :nameserver, :email, :serial, :refresh, :retry, :expire].each do |m|
        instance_variable_set("@#{m}".to_sym, nil)
        self.class.send :define_method, m, proc { |v| instance_variable_set("@#{m}", v) }
      end

      params = {ttl: domain.ttl_val, refresh: domain.ttl_val, retry: domain.ttl_val, expire: domain.ttl_val, serial: Date.today.strftime("%Y%m%d")}.merge(params)

      params.each do |key, value|
        self.send "#{key}", value if  self.respond_to? key
      end

      super domain, host, params
      instance_eval &block  if block_given?
    end

    def host
      @host.to_s
    end

    def type
      :SOA
    end

    def value
      ns = @nameserver.to_s
      if @nameserver.is_a?(DNS::Record)
        ns = @nameserver.full_host.to_s
      end
      em = @email.to_s.gsub('@', '.')
      em = em + '.' unless em.end_with?('.')
      "#{ns} #{em} (" + [@serial, @refresh, @retry, @expire, @ttl].join(' ') + ")"
    end
  end
end
