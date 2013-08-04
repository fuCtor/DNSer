require "rspec"
require ::File.expand_path('../../lib/dnser.rb', __FILE__)

describe DNSer::Record do

  def test_zone  &block
    io  = StringIO.new
    zone = DNSer.domain 'domain.ltd', builder: io, &block
    [zone, io]
  end

  context 'for Base record' do
    it "should create base record" do

      zone, io = test_zone
      expect( DNSer::BaseRecord.new(zone, :A, '1.1.1.1') ).to be_a(DNSer::BaseRecord)

    end

    it "should return correct type" do
      zone, io = test_zone
      expect( DNSer::BaseRecord.new(zone, :A, '1.1.1.1').type ).to eq(:A)
    end

    it "should return correct value" do
      zone, io = test_zone
      expect( DNSer::BaseRecord.new(zone, :A, '1.1.1.1').value ).to eq('1.1.1.1')
    end

    it "should return correct priority" do
      zone, io = test_zone
      expect( DNSer::BaseRecord.new(zone, :A, '1.1.1.1', priority: 1).value ).to eq('1 1.1.1.1')
    end

    it "should return correct host" do
      zone, io = test_zone
      expect( DNSer::BaseRecord.new(zone, :A, zone.host, '1.1.1.1').host ).to eq('@')
    end

    it "should return correct canonical host" do
      zone, io = test_zone
      expect( DNSer::BaseRecord.new(zone, :A, zone.host, '1.1.1.1').full_host ).to eq(zone.host)
    end

    it "should return correct priority" do
      zone, io = test_zone
      expect( DNSer::BaseRecord.new(zone, :A, zone.host, '1.1.1.1', priority: 10).priority ).to eq(10)
    end

    it "should support IPAddr as value" do
      zone, io = test_zone
      ip = IPAddr.new('1.1.1.1')
      expect( DNSer::BaseRecord.new(zone, :A, zone.host, ip).value ).to eq(ip.to_s)
    end

    it "should support another record as value" do
      zone, io = test_zone
      ip = IPAddr.new('1.1.1.1')
      record = DNSer::BaseRecord.new(zone, :A, zone.host, ip)
      expect( DNSer::BaseRecord.new(zone, :CNAME, 'www', record).value ).to eq(record)
    end

  end

  context 'for SOA record' do
    it "should create" do
      zone, io = test_zone
      expect( DNSer::SoaRecord.new(zone, zone.name, email: 'user@test.ltd', nameserver: '1.1.1.1') ).to be_a(DNSer::SoaRecord)
    end

    it "should return correct type" do
      zone, io = test_zone
      expect( DNSer::SoaRecord.new(zone, zone.name, email: 'user@test.ltd', nameserver: '1.1.1.1').type ).to eq(:SOA)
    end

    it "should validate email " do
      zone, io = test_zone
      expect{ DNSer::SoaRecord.new(zone, zone.name, nameserver: '1.1.1.1') }.to raise_error(DNSer::Record::EmptyValue)
    end

    it "should validate nameserver " do
      zone, io = test_zone
      expect{ DNSer::SoaRecord.new(zone, zone.name, email: 'user@test.ltd') }.to raise_error(DNSer::Record::EmptyValue)
    end

    it "should return correct email" do
      zone, io = test_zone
      expect( DNSer::SoaRecord.new(zone, zone.name, email: 'user@test.ltd', nameserver: '1.1.1.1').email ).to eq('user@test.ltd')
    end

    it "should return correct nameserver" do
      zone, io = test_zone
      expect( DNSer::SoaRecord.new(zone, zone.name, email: 'user@test.ltd', nameserver: '1.1.1.1').nameserver ).to eq('1.1.1.1')
    end

    it "should return correct value" do
      zone, io = test_zone
      expect( DNSer::SoaRecord.new(zone, zone.name, email: 'admin@domain.ltd', nameserver: 'ns1.domain.ltd.', serial: 100).value ).to eq('ns1.domain.ltd. admin.domain.ltd. 100 3600 3600 3600 3600')
    end

    it "should return correct host" do
      zone, io = test_zone
      expect( DNSer::SoaRecord.new(zone, zone.name, email: 'admin@domain.ltd', nameserver: 'ns1.domain.ltd.', serial: 100).host ).to eq(zone.host)
    end
  end

  context 'for SRV record' do
    it "should create " do
      zone, io = test_zone
      expect( DNSer::SrvRecord.new(zone, 'dev', '1.1.1.1', service: 'test', protocol: 'tcp', port: 80) ).to be_a(DNSer::BaseRecord)
    end

    it "should validate service " do
      zone, io = test_zone
      expect{ DNSer::SrvRecord.new(zone, 'dev', '1.1.1.1', protocol: 'tcp', port: 80) }.to raise_error(DNSer::Record::EmptyValue)
    end

    it "should validate protocol" do
      zone, io = test_zone
      expect{ DNSer::SrvRecord.new(zone, 'dev', '1.1.1.1', service: 'test', port: 80) }.to raise_error(DNSer::Record::EmptyValue)
    end

    it "should validate port " do
      zone, io = test_zone
      expect{ DNSer::SrvRecord.new(zone, 'dev', '1.1.1.1', service: 'test', protocol: 'tcp') }.to raise_error(DNSer::Record::EmptyValue)
    end

    it "should return correct value" do
      zone, io = test_zone
      expect( DNSer::SrvRecord.new(zone, 'dev', '1.1.1.1', service: 'test', protocol: 'tcp', port: 80, weight: 100, priority: 1).value ).to eq('1 100 80 1.1.1.1')
    end

    it "should return support host" do
      zone, io = test_zone
      expect( DNSer::SrvRecord.new(zone, 'dev', '1.1.1.1', service: 'test', protocol: 'tcp', port: 80, weight: 100, priority: 1).host ).to eq("_test._tcp.dev.#{zone.host}")
    end

    it "should  support weight" do
      zone, io = test_zone
      expect( DNSer::SrvRecord.new(zone, 'dev', '1.1.1.1', service: 'test', protocol: 'tcp', port: 80, weight: 100, priority: 1) ).to respond_to('weight')
    end
  end

end