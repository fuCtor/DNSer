require ::File.expand_path('../domain.rb', __FILE__)

module DNS
  def self.domain domain_name, params = {} , &block
    Domain.new domain_name, params, &block
  end
end
