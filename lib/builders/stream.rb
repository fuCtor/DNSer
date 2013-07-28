module DNS
  class StreamBuilder < Builder
    attr_reader :stream
    def initialize stream
      case stream
        when String
          @stream = File.new stream, 'w'
        when IO,File
          @stream = stream
        else
          raise 'Unknown stream type'
      end

      @buffer = []
    end

    def origin name
      @stream << ('$ORIGIN ' + name.to_s + "\n")
    end

    def ttl value
      @stream << ('$TTL ' + value.to_s + "\n")
    end

    def write *args
      if (args.count == 1)
        record = args.first
        write record.host, record.type, record.value, record.comment
      else

        value = args[2]
        if value.is_a? DNS::Record
          value = value.full_host
        else
          value = value.to_s
        end
        @buffer << {host: args[0].to_s, type: args[1].to_s.upcase ,value: value, comment: args[3] }
      end
    end

    def sync

      max_host_length = 0
      max_type_length = 0
      max_value_length = 0

      @buffer.each do |r|
        max_host_length = max_host_length < r[:host].size ? r[:host].length : max_host_length
        max_type_length = max_type_length < r[:type].size ? r[:type].length : max_type_length
        max_value_length = max_value_length < r[:value].size ? r[:value].length : max_value_length
      end

      @buffer.each do |r|
        @stream << r[:host].ljust(max_host_length + 2)
        @stream << 'IN ' + r[:type].ljust(max_type_length)
        @stream << "\t" +  r[:value].ljust(max_value_length)
        @stream << "\t##{r[:comment]}" unless r[:comment].empty?
        @stream << "\n"
      end

      @buffer.clear

    end
  end
end