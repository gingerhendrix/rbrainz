#!/usr/bin/env ruby
#
# Example script which queries the database for an
# artist and displays the artist's data.
# 
# $Id$

# Just make sure we can run this example from the command
# line even if RBrainz is not yet installed properly.
$: << 'lib/' << '../lib/'

# Load RBrainz and include the MusicBrainz namespace.
require 'rbrainz'
include MusicBrainz

# The artist's MusicBrainz ID.
# Either read it from the command line as the first
# parameter or use a default one for demonstration.
id = $*[0] ? $*[0] : '10bf95b6-30e3-44f1-817f-45762cdc0de0'

# Generate a new artist MBID object from the ID:
mbid = Model::MBID.parse(id, :artist)

# Define what information about the artist
# should be included in the result.
# In this case the artist's aliases and all
# the official albums by this artist will be
# fetched.
artist_includes = Webservice::ArtistIncludes.new(
  :aliases => true,
  :releases => [Model::Release::TYPE_ALBUM, Model::Release::TYPE_OFFICIAL]
)

# Create a new Query object which will provide
# us an interface to the MusicBrainz web service.
query = Webservice::Query.new

# Now query the MusicBrainz database for the artist
# with the MBID defined above.
# We could as well use the ID string directly instead
# of the MBID object.
artist = query.get_artist_by_id(mbid, artist_includes)

# Display the fetched artist data together with all
# unique release titles.
print <<EOF
ID            : #{artist.id.uuid}
Name          : #{artist.name}
Sort name     : #{artist.sort_name}
Disambiguation: #{artist.disambiguation}
Type          : #{artist.type}
Begin date    : #{artist.begin_date}
End date      : #{artist.end_date}
Aliases       : #{artist.aliases.to_a.join('; ')}
Releases      : #{artist.releases.map{|r| r.title}.uniq.join("\r\n                ")}
EOF