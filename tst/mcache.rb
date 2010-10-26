#!/usr/bin/env ruby
#
#

require 'yaml'
require 'socket'

conf = 'memcache-pool.yml'
list = []
pool = 'test'

yml = YAML::load(File.open('memcache-pool.yml'))

# pools:
# yml.each_key { |pool| puts "Pool: #{pool}" }

###
refs = open( conf ) { |f| YAML.load(f) }

refs[ pool ].each do |item|
    list.push( item )

    host, port = item.split(':')
    puts "Host: #{host} : #{port}"

    socket = TCPSocket.open( host, port )
    socket.send( "flush_all\r\n", 0 )
    print "Result: ", socket.recv(4096)
    socket.close
end

puts list.join ','
exec ("memcache-top","--sleep","1","--instances", list.join(","))

