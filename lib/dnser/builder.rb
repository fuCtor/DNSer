module DNSer
  class Builder
    def write *args
      raise NotImplementedError
    end

    def origin name
      raise NotImplementedError
    end

    def ttl value
      raise NotImplementedError
    end

    def sync
    end
  end
end

Dir.glob(::File.expand_path('../builders/*.rb', __FILE__)).each{|file| require file }
