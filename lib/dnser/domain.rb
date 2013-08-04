require 'date'
require 'ipaddr'

require ::File.expand_path('../record.rb', __FILE__)
require ::File.expand_path('../builder.rb', __FILE__)

module DNSer
  class Domain
    attr :name

    def initialize domain_name, params = {}, &block
      @name = domain_name

      @builder = params[:builder] || DNSer.config.output #DNSer::StreamBuilder.new($stdout)
      @builder = DNSer::StreamBuilder.new(@builder) unless @builder.is_a? DNSer::Builder

      @name = @name + '.' unless @name.end_with?('.')
      @ttl_val = 3600
      @records = []
      instance_exec self, &block if block

      dump
    end

    def name
      @name
    end

    alias_method :current, :name
    alias_method :host, :name

    def ttl(*args)
      @ttl_val = args.first unless args.empty?
      @ttl_val
    end

    def dump
      @builder.origin @name
      @builder.ttl @ttl_val

      @records_tmp = @records.dup

      soa_index = @records_tmp.index {|x| x.is_a?(DNSer::SoaRecord) }
      @builder.write @records_tmp.delete_at( soa_index ) if soa_index

      ns = []
      @records_tmp = @records_tmp.map do |r|
        if r.type.to_s.downcase == 'ns'
          @builder.write r
          nil
        else
          r
        end
      end .compact

#      @records_tmp.sort! {|x, y| x.host <=> y.host }
      @records_tmp.each {|r| @builder.write r }

      @builder.sync
    end

    def method_missing name, *args, &block
      name = name.to_s.downcase

      return DNSer.apply_template name.gsub('apply_', '') do |tpl|
        tpl.apply self, *args, &block
      end if name.start_with? 'apply_'

      params = args.last.dup if args.last.is_a? Hash

      record_class = begin
        eval "::DNSer::#{name.capitalize}Record"
      rescue NameError => e
        args = [name] + args
        DNSer::BaseRecord
      end

      record =  record_class.new(self, *args, &block)
      @records << record

      if params.key? :alias
        [params[:alias]].flatten.each do |host|
          @records << DNSer::BaseRecord.new(self, :CNAME, host, record, &block)
        end
      end if params

      record
    end


  end
end