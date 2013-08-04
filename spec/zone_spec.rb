require "rspec"
require ::File.expand_path('../../lib/dnser.rb', __FILE__)

describe DNSer::Domain do

  it "should create zone w block" do
    io  = StringIO.new
    zone = DNSer.domain 'domain.ltd', builder: io do

    end

    expect( zone ).to be_a(DNSer::Domain)
  end

  it "should create zone w/o block" do
    io  = StringIO.new
    expect( DNSer.domain('domain.ltd', builder: io) ).to be_a(DNSer::Domain)
  end

  it "should create zone with name" do
    io  = StringIO.new
    zone = DNSer.domain 'domain.ltd', builder: io
    expect(zone.name).to eq('domain.ltd.')
  end

  it "should create zone with builder" do
    io  = StringIO.new
    zone = DNSer.domain 'domain.ltd', builder: io

    expect(zone.name).to eq('domain.ltd.')
  end

  it "should write in builder" do
    io  = StringIO.new
    zone = DNSer.domain 'domain.ltd', builder: io

    expect(io.string).to eq("$ORIGIN domain.ltd.\n$TTL 3600\n")
  end

  it "should set zone ttl" do
    io  = StringIO.new
    zone = DNSer.domain 'domain.ltd', builder: io
    zone.ttl 100
    expect(zone.ttl).to eq(100)
  end

end