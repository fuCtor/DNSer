require ::File.expand_path('../base.rb', __FILE__)
module DNS
  class MxRecord < DNS::BaseRecord

    def initialize domain, host, value, params = {}, &block
      @priority_val = 0
      super domain, :MX, host, value, params, &block
    end

    def value

      target_host = canonical_host @value

      if @priority_val == 0
        target_host
      else
        "#{@priority_val} #{target_host}"
      end

    end

  end
end
