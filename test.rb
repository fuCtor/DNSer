require "./lib/dnser.rb"

template :google_app  do |host, code, params|

  TXT host, ('google-site-verification=' + code), :comment => "Google verifi"

  MX host, 'ASPMX.L.GOOGLE.COM.', :priority => 1, :comment => "GMail"
  MX host, 'ALT1.ASPMX.L.GOOGLE.COM.', :priority => 5, :comment => "GMail"
  MX host, 'ALT2.ASPMX.L.GOOGLE.COM.', :priority => 5, :comment => "GMail"
  MX host, 'ASPMX2.GOOGLEMAIL.COM.', :priority => 10, :comment => "GMail"
  MX host, 'ASPMX23.GOOGLEMAIL.COM.', :priority => 10, :comment => "GMail"
  TXT host, 'v=spf1 include:_spf.google.com ~all', :comment => "GMail SPF"

  %w(mail doc).each do |sub|
    CNAME [sub, host].join('.'), 'ghs.googlehosted.com.'
  end
end

zone 'domain.ltd' do
  ttl 3600
  ns = NS 'ns1', 'ns1.dnsimple.com.'

  SOA host do
    nameserver ns
    email 'admin@domain.ltd'
  end

  A host, IPAddr.new('127.0.0.1'), :alias => ['www']

  apply_google_app host, '6tTalLzrBXBO4Gy9700TAbpg2QTKzGYEuZ_Ls69jle8'
end