require "./lib/dnser.rb"

ipaddr1 = IPAddr.new "3ffe:505:2::1"
ipaddr2 = IPAddr.new "8.8.8.8"


template :my  do |params|
  A 'test', params[:ip]
  MX 'test', params[:ip]
end

zone 'test.ru' do
  ttl 3600
  ns = NS 'ns1', ipaddr2
  NS 'ns2', ipaddr2

  SOA host do
    nameserver ns
    email 'admin@test.ru'
  end

  A host, ipaddr2
  AAAA host, ipaddr1

  apply_my ip: '4.4.4.4'

  GOOGLE '6tTalLzrBXBO4Gy9700TAbpg2QTKzGYEuZ_Ls69jle8', :host => 'sub', :comment => "Google App"
end