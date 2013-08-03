require 'date'
require 'ipaddr'

require ::File.expand_path('../record.rb', __FILE__)
require ::File.expand_path('../builder.rb', __FILE__)

module DNS
  class Domain
    attr :name
    attr :ttl_val

    def initialize domain_name, params = {}, &block
      @name = domain_name
      @builder = params[:builder] || DNS::StreamBuilder.new($stdout)

      unless @builder.is_a? DNS::Builder
        @builder =  DNS::StreamBuilder.new(@builder)
      end

      @name = @name + '.' unless @name.end_with?('.')
      @ttl_val = 3600
      @records = []
      instance_exec self, &block

      @builder.origin @name
      @builder.ttl @ttl_val



      dump
    end

    def name
      @name
    end

    alias_method :current, :name
    alias_method :host, :name

    def ttl(t)
      @ttl_val
    end

    def dump
      @records_tmp = @records.dup

      soa_index = @records_tmp.index {|x| x.is_a?(DNS::SoaRecord) }
      @builder.write @records_tmp.delete_at( soa_index ) if soa_index

      ns = []
      @records_tmp.each do |r|
        if r.type.to_s.downcase == 'ns'
          @builder.write r
          ns << r
        end
      end

      @records_tmp = @records_tmp - ns

      @records_tmp.sort! {|x, y|
        x.host <=> y.host
      }

      @records_tmp.each {|r| @builder.write r }

      @builder.sync
    end

    def method_missing name, *args, &block
      class_name = '::DNS::' + name.to_s.downcase.capitalize + 'Record'
      record_class = nil


      if name.to_s.downcase.start_with? 'apply_'
        @tpl = DNS.template name.to_s.downcase.gsub('apply_', '')

        if @tpl
          @tpl.apply self, *args, &block
          return @tpl
        end

        raise 'Unknown DNS template'
      end

      cnames = []
      if args.last.is_a? Hash
        params = args.pop
        args.push params
        cnames = params.delete(:alias).to_a || []
      end

      begin
        eval "record_class = #{class_name}"
        @records << record_class.new(self, *args, &block)
      rescue => e
        @records << DNS::BaseRecord.new(self, name, *args, &block)
      end

      record = @records.last

      cnames.each do |host|
        @records << DNS::BaseRecord.new(self, :CNAME, host, record, &block)
      end

      record
    end


  end
end