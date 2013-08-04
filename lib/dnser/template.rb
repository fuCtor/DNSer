module DNSer
  class Template
    def initialize(params = {}, &block)
      @block = block
      @params = params
    end

    def apply(domain, *args, &block)
      if args.last.is_a? Hash
        args.push @params.merge(args.pop)
      else
        args.push @params
      end
      domain.instance_exec *args, &@block if @block
      domain.instance_exec *args, &block if block
    end

    class Unknown < RuntimeError
      attr_reader :name
      def initialize name
        @name = name
      end
    end
  end
end
