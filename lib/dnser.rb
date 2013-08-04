require ::File.expand_path('../dnser/domain.rb', __FILE__)
require ::File.expand_path('../dnser/template.rb', __FILE__)
require 'singleton'

module DNSer

  def self.domain domain_name, params = {} , &block
    Domain.new domain_name, params, &block
  end

  def self.create_template name, params = {}, &block
    @templates ||= {}
    @templates[name.to_s.downcase.to_sym] = DNSer::Template.new params, &block
  end

  def self.apply_template name, &block
    if @templates
      tpl = @templates[name.to_s.downcase.to_sym].dup rescue nil
      yield tpl if tpl if block_given?
      raise Template::Unknown.new(name.to_s.downcase.to_sym), 'Unknown DNS template' unless tpl
      tpl
    end
  end

  def self.config
    Config.instance
  end


  class Config
    include ::Singleton

    attr_accessor :output, :full_domain

    def output
      @output ||= DNSer::StreamBuilder.new($stdout)
    end
    def full_domain
      @full_domain ||= false
    end

  end

end

def zone *args  , &block
  DNSer.domain *args , &block
end

def template *args  , &block
  DNSer.create_template *args , &block
end