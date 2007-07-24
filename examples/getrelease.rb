#!/usr/bin/env ruby
#
# Example script which queries the database for an
# release and displays the release's data.
# 
# $Id$

# Just make sure we can run this example from the command
# line even if RBrainz is not yet installed properly.
$: << 'lib/' << '../lib/'

# Load RBrainz and include the MusicBrainz namespace.
require 'rbrainz'
include MusicBrainz

# The release's MusicBrainz ID.
# Either read it from the command line as the first
# parameter or use a default one for demonstration.
id = $*[0] ? $*[0] : '6785cad0-159c-40ec-9ee4-30d8745dd7f9'

# Generate a new release MBID object from the ID:
mbid = Model::MBID.parse(id, :release)

# Define what information about the release
# should be included in the result.
# In this case the release artist and the tracks
# on the release will be fetched as well.
release_includes = Webservice::ReleaseIncludes.new(
  :artist => true,
  :tracks => true
)

# Create a new Query object which will provide
# us an interface to the MusicBrainz web service.
query = Webservice::Query.new

# Now query the MusicBrainz database for the release
# with the MBID defined above.
# We could as well use the ID string directly instead
# of the MBID object.
release = query.get_release_by_id(mbid, release_includes)

# Display the fetched release data together with all
# unique release titles.
print <<EOF
ID            : #{release.id.uuid}
Title         : #{release.title}
Artist        : #{release.artist.unique_name}
Tracks        : #{release.tracks.to_a.join("\r\n                ")}
EOF