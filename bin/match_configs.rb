#!/usr/bin/env ruby
# returns a JSON string, listing config files that are common between two directories
# - used to get all configurations in clas12-config

require 'json'

dirs = Array.new
unless ARGV.length == 2
  $stderr.puts "USAGE: #{$0} [dir1] [dir2]"
  exit 2
end
dirs = ARGV

files = dirs.map{ |d|
  ['gcard', 'yaml'].map{ |ext|
    Dir.glob("#{d}/*.#{ext}")
      .map{ |f| f.split('/')[-1].sub /\.#{ext}$/, '' }
  }.flatten
}

unless files.length==2
  $stderr.puts "ERROR: files array does not have 2 elements"
  exit 1
end

filesMatched = files[0].select{ |f| files[1].include? f }
puts JSON.generate({ 'config' => filesMatched })
