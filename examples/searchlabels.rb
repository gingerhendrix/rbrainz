#!/usr/bin/env ruby
#
# Example script which searches the database for
# labels and displays the label's data.
# 
# $Id$

# Just make sure we can run this example from the command
# line even if RBrainz is not yet installed properly.
$: << 'lib/' << '../lib/'

# Load RBrainz and include the MusicBrainz namespace.
require 'rbrainz'
include MusicBrainz

# Define the search parameters: Search for labels with the
# name "Paradise Lost" and return a maximum of 10 labels.
label_filter = Webservice::LabelFilter.new(
  :name  => 'Century',
  :limit => 10
)

# Create a new Query object which will provide
# us an interface to the MusicBrainz web service.
query = Webservice::Query.new

# Now query the MusicBrainz database for labels
# with the search parameters defined above.
labels = query.get_labels(label_filter)

# Display the fetched label's names and the score, which
# indicates how good the label matches the search parameters.
labels.each do |entry|
  print "%s (%i%%)\r\n" % [entry.entity.unique_name, entry.score]
end