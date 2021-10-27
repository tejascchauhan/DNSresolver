def get_command_line_argument
  # ARGV is an array that Ruby defines for us,
  # which contains all the arguments we passed to it
  # when invoking the script from the command line.
  # https://docs.ruby-lang.org/en/2.4.0/ARGF.html
  if ARGV.empty?
    puts "Usage: ruby lookup.rb <domain>"
    exit
  end
  ARGV.first
end

# `domain` contains the domain name we have to look up.
domain = get_command_line_argument

# File.readlines reads a file and returns an
# array of string, where each element is a line
# https://www.rubydoc.info/stdlib/core/IO:readlines
dns_raw = File.readlines("zone")

# ..
# ..
# FILL YOUR CODE HERE
def parse_dns(dns_raw)
  dns_records = Hash.new
  dns_raw.each.with_index do |line, i|
    if line.length > 1 && line[0] != '#'
      array = dns_raw[i].split(',')
      dns_record = array.map{ |e| e.strip }
      dns_records.store( dns_record[1], {:type => dns_record[0], :add => dns_record[2]})
    end
  end
  return dns_records
end

def resolve(dns_records, lookup_chain, domain)

  record = dns_records[domain]
  if(record==nil)
    return lookup_chain=["Error: record not found for #{domain}"]
  elsif (record[:type]=="A")
    lookup_chain.append(record[:add])
  else
    lookup_chain.append(record[:add])
    resolve(dns_records, lookup_chain, record[:add])
  end
  return lookup_chain
end
# ..
# ..

# To complete the assignment, implement `parse_dns` and `resolve`.
# Remember to implement them above this line since in Ruby
# you can invoke a function only after it is defined.
dns_records = parse_dns(dns_raw)
lookup_chain = [domain]
lookup_chain = resolve(dns_records, lookup_chain, domain)
puts lookup_chain.join(" => ")
