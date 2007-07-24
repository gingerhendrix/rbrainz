#!/usr/bin/env ruby
#
# Example script which searches the database for
# tracks and displays the track data.
# 
# $Id$

# Just make sure we can run this example from the command
# line even if RBrainz is not yet installed properly.
$: << 'lib/' << '../lib/'

# Load RBrainz and include the MusicBrainz namespace.
require 'rbrainz'
include MusicBrainz

# Define the search parameters: Search for releases with the
# title "Paradise Lost" and return a maximum of 10 releases.
track_filter = Webservice::TrackFilter.new(
  :title  => 'Shadowkings',
  :limit => 10
)

# Create a new Query object which will provide
# us an interface to the MusicBrainz web service.
query = Webservice::Query.new

# Now query the MusicBrainz database for tracks
# with the search parameters defined above.
tracks = query.get_tracks(track_filter)

# Display the fetched track titles and the score, which
# indicates how good the track matches the search parameters.
tracks.each do |entry|
  print "%s: \"%s\" (%i%%)\r\n" % [entry.entity.artist, entry.entity.title, entry.score]
end