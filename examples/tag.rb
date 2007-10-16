#!/usr/bin/env ruby
#
# Example script showing the use of folksonomy tagging with RBrainz.
# It asks the user for his username and password and a MBID and queries the
# MusicBrainz server for the tags, the user has applied to the entitity with
# the given MBID. Afterwards the user can submit new tags.
# 
# $Id: getuser.rb 145 2007-07-19 13:11:44Z phw $

# Just make sure we can run this example from the command
# line even if RBrainz is not yet installed properly.
$: << 'lib/' << '../lib/'

# Load RBrainz and include the MusicBrainz namespace.
require 'rbrainz'
include MusicBrainz

# Get the username and password
print 'Username: ' unless ARGV[0]
username = ARGV[0] ? ARGV[0] : STDIN.gets.strip
print 'Password: ' unless ARGV[1]
password = ARGV[1] ? ARGV[1] : STDIN.gets.strip

# Ask for a MBID to tag.
print 'Enter a MBID: '
mbid = Model::MBID.new(STDIN.gets.strip)

ws = Webservice::Webservice.new(:username=>username, :password=>password) 

# Create a new Query object which will provide
# us an interface to the MusicBrainz web service.
query = Webservice::Query.new(ws, :client_id => 'RBrainz test ' + RBRAINZ_VERSION)

# Read and print the current tags for the given MBID
tags = query.get_user_tags(mbid)
print 'Current tags: '
puts tags.to_a.join(', ')

# Ask the user for new tags and submit them
print 'Enter new tags: '
new_tags = STDIN.gets.strip
query.submit_user_tags(mbid, new_tags)