require ::File.expand_path('../domain.rb', __FILE__)
require ::File.expand_path('../template.rb', __FILE__)

module DNS

  def self.domain domain_name, params = {} , &block
    Domain.new domain_name, params, &block
  end

  def self.create_template name, params = {}, &block
    @templates ||= {}
    @templates[name.to_s.downcase.to_sym] = DNS::Template.new params, &block
  end

  def self.apply_template name, &block
    if @templates
      tpl = @templates[name.to_s.downcase.to_sym].dup rescue nil
      yield tpl if tpl
      raise 'Unknown DNS template' unless tpl
      tpl
    end
  end

end

def zone *args  , &block
  DNS.domain *args , &block
end

def template *args  , &block
  DNS.create_template *args , &block
end