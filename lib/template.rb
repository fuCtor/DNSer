module DNS
  class Template
    def initialize(params = {}, &block)
      @block = block
      @params = params
    end

    def apply(domain, params = {}, &block)
      params = @params.merge(params)
      domain.instance_exec params, &@block if @block
      domain.instance_exec params, &block if block
    end
  end
end