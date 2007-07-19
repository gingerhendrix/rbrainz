#!/usr/bin/env ruby
#
# Example script which queries the database for a
# User
# 
# $Id$

# Just make sure we can run this example from the command
# line even if RBrainz is not yet installed properly.
$: << 'lib/' << '../lib/'

# Load RBrainz and include the MusicBrainz namespace.
require 'rbrainz'
include MusicBrainz

print 'Username: ' unless ARGV[0]
username = ARGV[0] ? ARGV[0] : STDIN.gets.strip
print 'Password: ' unless ARGV[1]
password = ARGV[1] ? ARGV[1] : STDIN.gets.strip

ws = Webservice::Webservice.new(:username=>username, :password=>password)

# Create a new Query object which will provide
# us an interface to the MusicBrainz web service.
query = Webservice::Query.new(ws)

user = query.get_user_by_name(username)
puts "Name   : " + user.name
puts "ShowNag: " + user.show_nag?.to_s
puts "Types  : " + user.types.join(' ')
