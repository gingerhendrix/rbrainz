#!/usr/bin/env ruby
#
# Example script which searches the database for
# releases and displays the release data.
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
release_filter = Webservice::ReleaseFilter.new(
  :artistid => '10bf95b6-30e3-44f1-817f-45762cdc0de0',
  :limit => 10
)

# Create a new Query object which will provide
# us an interface to the MusicBrainz web service.
query = Webservice::Query.new

# Now query the MusicBrainz database for releases
# with the search parameters defined above.
releases = query.get_releases(release_filter)

# Display the fetched release titles and the score, which
# indicates how good the release matches the search parameters.
releases.each do |entry|
  print "%s: %s (%i%%)\r\n" % [entry.entity.earliest_release_date,
                               entry.entity.title, entry.score]
end