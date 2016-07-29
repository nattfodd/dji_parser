module DjiParser
  module BinreadHelpers

    private

    def read_double(offset)
      @buffer.unpack("@#{@block_offset + offset}E").first
    end

    def read_signed_short(offset)
      @buffer.unpack("@#{@block_offset + offset}s").first
    end

    def read_unsigned_short(offset)
      @buffer.unpack("@#{@block_offset + offset}S").first
    end

    def read_unsigned_int(offset)
      @buffer.unpack("@#{@block_offset + offset}L").first
    end

    def read_unsigned_char(offset)
      @buffer.unpack("@#{@block_offset + offset}C").first
    end
  end
end
