require 'dji_parser/version'
require 'dji_parser/osd'
require 'json'
require 'byebug'

module DjiParser

  TYPES = {
    1   => :osd,
    2   => :home,
    3   => :gimbal,
    4   => :rc,
    5   => :custom,
    6   => :deform,
    7   => :center_battery,
    8   => :smart_battery,
    9   => :app_tip,
    10  => :app_warn,
    11  => :rc_gps,
    12  => :rc_debug,
    13  => :recover,
    14  => :app_gps,
    15  => :firmware,
    255 => :end,
    254 => :other
  }

  KEEP_PARSING_MARK = 255

  # ToDo: make 'offset' instance variable

  def self.parse(dji_bin_file)
    buffer = File.binread(dji_bin_file)

    # first 3 header bytes show address, where Details section starts
    details_offset = buffer.unpack('S!').first

    # packets start at offset 12
    offset = 12

    data = []
    loop do
      break if offset >= details_offset

      t_id = buffer.unpack("@#{offset}C").first
      offset += 1
      type = TYPES[t_id]

      length = buffer.unpack("@#{offset}C").first
      offset += 1

      end_offset = buffer.unpack("@#{offset + length}C").first
      break if end_offset != KEEP_PARSING_MARK

      case(type)
      when :osd
        data << Osd.new(buffer, offset)
      when :home
        # ToDo
      when :gimbal
        # ToDo
      else
        # ToDo
      end

      offset += length + 1;
    end

    data
  end
end
