##### Wrong
class EnhanceWriter
  attr_reader :check_sum

  def initialize(path)
    @file = File.open(path, 'w')
    @check_sum = 0
    @line_number = 1
  end

  def write_line(line)
    @file.print(line)
    @file.print("\n")
  end

  def checksumming_write_line(data)
    # p data.each_byte
    data.each_byte {|byte| @check_sum = (@check_sum + byte) % 256 }
    @check_sum += "\n".each_byte.first % 256
    write_line(data)
  end

  def timestamping_write_line(data)
    write_line("#{Time.new}: #{data}")
  end
  
  def numbering_write_line(data)
    write_line("#{@line_number}: #{data}")
    @line_number += 1
  end

  def close
    @file.close
  end  
end

writer = EnhanceWriter.new('out.txt')
writer.write_line("plain line")

writer.checksumming_write_line('line with checksum')
puts("checksum is #{writer.check_sum}")

writer.timestamping_write_line('with time stamp')
writer.numbering_write_line('with line number')