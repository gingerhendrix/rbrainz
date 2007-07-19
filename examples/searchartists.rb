#!/usr/bin/env ruby
#
# Example script which searches the database for
# artists and displays the artist's data.
# 
# $Id$

# Just make sure we can run this example from the command
# line even if RBrainz is not yet installed properly.
$: << 'lib/' << '../lib/'

# Load RBrainz and include the MusicBrainz namespace.
require 'rbrainz'
include MusicBrainz

# Define the search parameters: Search for artists with the
# name "Paradise Lost" and return a maximum of 10 artists.
artist_filter = Webservice::ArtistFilter.new(
  :name  => 'Paradise Lost',
  :limit => 10
)

# Create a new Query object which will provide
# us an interface to the MusicBrainz web service.
query = Webservice::Query.new

# Now query the MusicBrainz database for artists
# with the search parameters defined above.
artists = query.get_artists(artist_filter)

# Display the fetched artist's names and the score, which
# indicates how good the artist matches the search parameters.
artists.each do |entry|
  print "%s (%i%%)\r\n" % [entry.entity.unique_name, entry.score]
end