module DNS
  class Template
    def initialize(params = {}, &block)
      @block = block
      @params = params
    end

    def apply(domain, *args, &block)
      if args.last.is_a? Hash
        args.push @params.merge(args.pop)
      end
      domain.instance_exec *args, &@block if @block
      domain.instance_exec *args, &block if block
    end
  end
end