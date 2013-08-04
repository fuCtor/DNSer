require "rspec"
require ::File.expand_path('../../lib/dnser.rb', __FILE__)

describe DNSer::Domain do

  it "should create zone w block" do
    io  = StringIO.new
    zone = DNSer.domain 'domain.ltd', builder: io do

    end
    zone.should_not eq(nil)
  end

  it "should create zone w/o block" do
    io  = StringIO.new
    zone = DNSer.domain 'domain.ltd', builder: io

    zone.should_not eq(nil)
  end

  it "should create zone with name" do
    io  = StringIO.new
    zone = DNSer.domain 'domain.ltd', builder: io
    zone.name.should eq('domain.ltd.')
  end

  it "should create zone with builder" do
    io  = StringIO.new
    zone = DNSer.domain 'domain.ltd', builder: io

    zone.name.should eq('domain.ltd.')
  end

  it "should write in builder" do
    io  = StringIO.new
    zone = DNSer.domain 'domain.ltd', builder: io

    io.string.should eq("$ORIGIN domain.ltd.\n$TTL 3600\n")
  end

  it "should set zone ttl" do
    io  = StringIO.new
    zone = DNSer.domain 'domain.ltd', builder: io
    zone.ttl 100
    zone.ttl.should eq(100)
  end

end