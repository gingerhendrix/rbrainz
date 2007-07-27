#!/usr/bin/env ruby
#
# Example script which queries the database for an
# track and displays the track's data.
# 
# $Id$

# Just make sure we can run this example from the command
# line even if RBrainz is not yet installed properly.
$: << 'lib/' << '../lib/'

# Load RBrainz and include the MusicBrainz namespace.
require 'rbrainz'
include MusicBrainz

# The track's MusicBrainz ID.
# Either read it from the command line as the first
# parameter or use a default one for demonstration.
id = $*[0] ? $*[0] : 'c29715ad-9a28-4f2b-9b64-4b899b06ac2a'

# Generate a new track MBID object from the ID:
mbid = Model::MBID.parse(id, :track)

# Define what information about the track
# should be included in the result.
# In this case the track artist and the releases
# the track appears on will be fetched as well.
track_includes = Webservice::TrackIncludes.new(
  :artist => true,
  :releases => true
)

# Create a new Query object which will provide
# us an interface to the MusicBrainz web service.
query = Webservice::Query.new

# Now query the MusicBrainz database for the track
# with the MBID defined above.
# We could as well use the ID string directly instead
# of the MBID object.
track = query.get_track_by_id(mbid, track_includes)

# Display the fetched track data together with all
# unique track titles.
print <<EOF
ID            : #{track.id.uuid}
Title         : #{track.title}
Duration      : #{track.duration/1000} seconds
Artist        : #{track.artist.unique_name}
Release       : #{track.releases.to_a.join("\r\n                ")}
EOF