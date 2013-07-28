require ::File.expand_path('../base.rb', __FILE__)

module DNS
  class GoogleRecord < DNS::BaseRecord

    def initialize domain, code, params = {}, &block
      host = (params.delete(:host) || domain.name)
      comment = params[:comment]

      super domain, :TXT, host, ('google-site-verification='+code),  params

      domain.instance_eval do
        MX host.to_s, 'ASPMX.L.GOOGLE.COM.', :priority => 1, :comment => comment
        MX host, 'ALT1.ASPMX.L.GOOGLE.COM.', :priority => 5, :comment => comment
        MX host, 'ALT2.ASPMX.L.GOOGLE.COM.', :priority => 5, :comment => comment
        MX host, 'ASPMX2.GOOGLEMAIL.COM.', :priority => 10, :comment => comment
        MX host, 'ASPMX23.GOOGLEMAIL.COM.', :priority => 10, :comment => comment
        CNAME ['mail', host].join('.'), 'ghs.googlehosted.com.', :comment => comment
        CNAME ['www', host].join('.'), 'ghs.googlehosted.com.', :comment => comment
        TXT host, 'v=spf1 include:_spf.google.com ~all', :comment => comment

      end

      instance_eval   if block_given?
    end

  end
end
