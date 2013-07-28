require ::File.expand_path('../base.rb', __FILE__)
module DNS
  class MxRecord < DNS::BaseRecord
    attr :priority_val

    def initialize domain, host, value, params = {}, &block
      @priority_val = 0
      super domain, :MX, host, value, params, &block
    end

    def value

      target_host = @value.to_s
      target_host = target_host + '.' unless target_host.end_with? '.'
      if @value.is_a?(DNS::Record)
        target_host = @value.full_host.to_s
      end

      if @priority_val == 0
        target_host
      else
        "#{priority_val} #{target_host}"
      end

    end

    def priority v
      @priority_val = v
    end
  end
end
