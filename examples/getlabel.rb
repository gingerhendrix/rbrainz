#!/usr/bin/env ruby
#
# Example script which queries the database for an
# label and displays the label's data.
# 
# $Id$

# Just make sure we can run this example from the command
# line even if RBrainz is not yet installed properly.
$: << 'lib/' << '../lib/'

# Load RBrainz and include the MusicBrainz namespace.
require 'rbrainz'
include MusicBrainz

# The label's MusicBrainz ID.
# Either read it from the command line as the first
# parameter or use a default one for demonstration.
id = $*[0] ? $*[0] : '727ad90b-7ef4-48d2-8f16-c34016544822'

# Generate a new label MBID object from the ID:
mbid = Model::MBID.parse(id, :label)

# Define what information about the label
# should be included in the result.
# In this case the label's aliases will be
# fetched as well.
label_includes = Webservice::LabelIncludes.new(
  :aliases => true
)

# Create a new Query object which will provide
# us an interface to the MusicBrainz web service.
query = Webservice::Query.new

# Now query the MusicBrainz database for the label
# with the MBID defined above.
# We could as well use the ID string directly instead
# of the MBID object.
label = query.get_label_by_id(mbid, label_includes)

# Display the fetched label data together with all
# unique release titles.
print <<EOF
ID            : #{label.id.uuid}
Name          : #{label.name}
Sort name     : #{label.sort_name}
Disambiguation: #{label.disambiguation}
Type          : #{label.type}
Begin date    : #{label.begin_date}
End date      : #{label.end_date}
Aliases       : #{label.aliases.to_a.join('; ')}
EOF