require ::File.expand_path('../dnser/domain.rb', __FILE__)
require ::File.expand_path('../dnser/template.rb', __FILE__)

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

end

def zone *args  , &block
  DNSer.domain *args , &block
end

def template *args  , &block
  DNSer.create_template *args , &block
end