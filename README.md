DNSer
=====

Ruby DSL for create DNS Zone file

    ipaddr1 = IPAddr.new "3ffe:505:2::1"
    ipaddr2 = IPAddr.new "8.8.8.8"
    
    DNS.domain 'test.ru' do
      ttl 3600
      ns = NS 'ns1', ipaddr2
      NS 'ns2', ipaddr2
    
      SOA host do
        nameserver ns
        email 'admin@test.ru'
      end
    
      A host, ipaddr2
      AAAA host, ipaddr1
    
      GOOGLE '6tTalLzrBXBO4Gy9700TAbpg2QTKzGYEuZ_Ls69jle8', :host => 'sub', :comment => "Google App"
    end
   
Result:

    $ORIGIN test.ru.
    $TTL 3600
    test.ru.  IN SOA    ns1.test.ru. admin.test.ru. (20130728 3600 3600 3600 3600)  
    ns1   IN NS   	8.8.8.8 
    ns2   IN NS   	8.8.8.8 
    @ IN A	8.8.8.8 
    @ IN AAAA 	3ffe:505:2::1   
    mail.sub  IN CNAME	ghs.googlehosted.com.   	#Google App
    sub   IN MX   	10 ASPMX2.GOOGLEMAIL.COM.	#Google App
    sub   IN MX   	5 ALT2.ASPMX.L.GOOGLE.COM.  	#Google App
    sub   IN MX   	5 ALT1.ASPMX.L.GOOGLE.COM.  	#Google App
    sub   IN MX   	10 ASPMX23.GOOGLEMAIL.COM.   	 #Google App
    sub   IN TXT  	"v=spf1 include:_spf.google.com ~all"   	#Google App
    sub   IN TXT  	google-site-verification=6tTalLzrBXBO4Gy9700TAbpg2QTKzGYEuZ_Ls69jle8 	#Google App
    sub   IN MX   	1 ASPMX.L.GOOGLE.COM.   	#Google App
    www.sub   IN CNAME	ghs.googlehosted.com.   	#Google App
  
