DNSer
=====

Ruby DSL for create DNS Zone file

```ruby
template :google_app  do |host, code, params|

  TXT host, ('google-site-verification=' + code), :comment => "Google verification code"

  MX host, 'ASPMX.L.GOOGLE.COM.', priority: 1, comment: "GMail"
  MX host, 'ALT1.ASPMX.L.GOOGLE.COM.', priority: 5, comment: "GMail"
  MX host, 'ALT2.ASPMX.L.GOOGLE.COM.', priority: 5, comment: "GMail"
  MX host, 'ASPMX2.GOOGLEMAIL.COM.', priority: 10, comment: "GMail"
  MX host, 'ASPMX23.GOOGLEMAIL.COM.', priority: 10, comment: "GMail"
  TXT host, 'v=spf1 include:_spf.google.com ~all', comment: "GMail SPF"

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

  A IPAddr.new('127.0.0.1'), alias: :www

  A :dev, IPAddr.new('127.0.0.2')

  apply_google_app host, '6tTalLzrBXBO4Gy9700TAbpg2QTKzGYEuZ_Ls69jle8'
end
```

Result:

    $ORIGIN domain.ltd.
    $TTL 3600
    domain.ltd.  IN SOA  	ns1.domain.ltd. admin.domain.ltd. (20130803 3600 3600 3600 3600)
    ns1          IN NS   	ns1.dnsimple.com.
    @            IN A    	127.0.0.1
    @            IN TXT  	"v=spf1 include:_spf.google.com ~all"                               	#GMail SPF
    @            IN MX   	10 ASPMX23.GOOGLEMAIL.COM.                                          	#GMail
    @            IN TXT  	google-site-verification=6tTalLzrBXBO4Gy9700TAbpg2QTKzGYEuZ_Ls69jle8	#Google verification code
    @            IN MX   	1 ASPMX.L.GOOGLE.COM.                                               	#GMail
    @            IN MX   	5 ALT1.ASPMX.L.GOOGLE.COM.                                          	#GMail
    @            IN MX   	10 ASPMX2.GOOGLEMAIL.COM.                                           	#GMail
    @            IN MX   	5 ALT2.ASPMX.L.GOOGLE.COM.                                          	#GMail
    dev          IN A    	127.0.0.2
    doc          IN CNAME	ghs.googlehosted.com.
    mail         IN CNAME	ghs.googlehosted.com.
    www          IN CNAME	domain.ltd.
