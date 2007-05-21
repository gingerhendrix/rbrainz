$: << 'lib/'

require 'rbrainz'
include MusicBrainz

mbid = Model::MBID.from_uuid(:release, '6a2ca1ac-408d-49b0-a7f6-cd608f2f684f')
print mbid
print "\n"

mbid = Model::MBID.from_uri('http://musicbrainz.org/artist/c0b2500e-0cef-4130-869d-732b23ed9df5')
print mbid
print "\n"

entity = Model::Artist.new
entity.id = mbid

artist_includes = Webservice::ArtistIncludes.new(
  :aliases => true,
  :releases => ['Album', 'Official'],
  :artist_rels => true,
  :release_rels => true,
  :track_rels => true,
  :label_rels => true,
  :url_rels => true
)
print artist_includes
print "\n"

q = Webservice::Query.new
#artist = q.get_artist_by_id(mbid, artist_includes)
#
#require 'yaml'
#print artist.to_yaml
#
#print <<EOF
#ID            : #{artist.id}
#Name          : #{artist.name}
#Sort name     : #{artist.sort_name}
#Disambiguation: #{artist.disambiguation}
#Type          : #{artist.type}
#Begin date    : #{artist.begin_date}
#End date      : #{artist.end_date}
#Aliases       : #{artist.aliases.join('; ')}
#EOF

require 'date'
d1 = Model::IncompleteDate.new '2007-05-02'
d2 = Date.parse '2007-05-03'
#d1 = Model::IncompleteDate.new d2

print d1.to_s + ' <=> ' + d2.to_s + ' = ' + (d1 <=> d2).to_s