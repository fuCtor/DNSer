require "rspec"
require ::File.expand_path('../../lib/dnser.rb', __FILE__)

describe DNSer::Template do

  def test_zone  &block
    io  = StringIO.new
    zone = DNSer.domain 'domain.ltd', builder: io, &block
    [zone, io]
  end

  it "should create template" do
    expect( DNSer::create_template(:empty) ).to be_a(DNSer::Template )
  end

  it "should be available" do
    expect(DNSer::apply_template(:empty)).to be_a(DNSer::Template)
  end

  it "should be throw error on unknown template" do
    expect { DNSer::apply_template :other }.to raise_error(DNSer::Template::Unknown)
  end

  it 'should apply template for zone' do

    DNSer::create_template(:first) do
      A host, '1.1.1.1'
    end
    zone, io = test_zone do
      apply_first
    end

    expect(io.string).to include('IN A')
  end

  it 'should arguments params' do
    DNSer::create_template(:first) do |arg|
      A host, arg
    end

    zone, io = test_zone  do
      apply_first 'test.com.'
    end

    expect(io.string).to include('test.com.')
  end

  it 'should support default params' do

    DNSer::create_template(:first, host: 'sub', target: 'domain.ltd.') do |arg, params|
      A params[:host], params[:target]
    end

    zone, io = test_zone do
      apply_first 'test.com.'
    end

    expect(io.string).to include('sub')
    expect(io.string).to include('domain.ltd.')
  end

  it 'should apply with params' do

    zone, io = test_zone do
      apply_first 'test.com.', target: 'foo.ltd.'
    end

    expect(io.string).to include('foo.ltd.')
  end
end