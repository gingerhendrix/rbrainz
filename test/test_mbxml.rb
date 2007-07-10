# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'test/unit'
require 'rbrainz'
include MusicBrainz

# Unit test for the MBXML class.
# 
# We test against the official test files supplied by
# MusicBrainz. See http://bugs.musicbrainz.org/browser/mmd-schema/trunk/test-data
class TestMBXML < Test::Unit::TestCase

  DATA_PATH = 'test/test-data/valid/'

  def setup
  end

  def teardown
  end
  
  def test_empty
    # The first test result is completely empty
    mbxml = Webservice::MBXML.new IO.read(DATA_PATH + 'artist/empty_1.xml')
    assert_equal nil, mbxml.get_entity(:artist)
    assert_equal nil, mbxml.get_entity(:release)
    assert_equal nil, mbxml.get_entity(:track)
    assert_equal nil, mbxml.get_entity(:label)
    assert_equal nil, mbxml.get_entity_list(:artist)
    assert_equal nil, mbxml.get_entity_list(:release)
    assert_equal nil, mbxml.get_entity_list(:track)
    assert_equal nil, mbxml.get_entity_list(:label)
    
    # The second contains an empty artist list
    mbxml = Webservice::MBXML.new IO.read(DATA_PATH + 'artist/empty_2.xml')
    assert_equal nil, mbxml.get_entity(:artist)
    assert_equal nil, mbxml.get_entity(:release)
    assert_equal nil, mbxml.get_entity(:track)
    assert_equal nil, mbxml.get_entity(:label)
    assert mbxml.get_entity_list(:artist).empty?
    assert_equal nil, mbxml.get_entity_list(:release)
    assert_equal nil, mbxml.get_entity_list(:track)
    assert_equal nil, mbxml.get_entity_list(:label)
  end
  
  def test_artist_search
    mbxml = Webservice::MBXML.new IO.read(DATA_PATH + 'artist/search_result_1.xml')
    assert_equal nil, mbxml.get_entity(:artist)
    assert_equal nil, mbxml.get_entity(:release)
    assert_equal nil, mbxml.get_entity(:track)
    assert_equal nil, mbxml.get_entity(:label)

    artist_list = mbxml.get_entity_list(:artist)
    assert_equal 0, artist_list.offset
    assert_equal 47, artist_list.count
    
    assert_equal 3, artist_list.size, artist_list.inspect
    assert_equal 'c0b2500e-0cef-4130-869d-732b23ed9df5', artist_list[0][:entity].id.uuid
    assert_equal Model::Artist::TYPE_PERSON, artist_list[0][:entity].type
    assert_equal 'Tori Amos', artist_list[0][:entity].name
    assert_equal 'Amos, Tori', artist_list[0][:entity].sort_name
    assert_equal '1963-08-22', artist_list[0][:entity].begin_date.to_s
    assert_equal 100, artist_list[0][:score]
    assert_equal 44, artist_list[1][:score]
    assert_equal 44, artist_list[2][:score]
  end
  
  def test_artist_tchaikovsky_1
    mbxml = Webservice::MBXML.new IO.read(DATA_PATH + 'artist/Tchaikovsky-1.xml')
    artist = mbxml.get_entity(:artist)
    
    assert_equal '9ddd7abc-9e1b-471d-8031-583bc6bc8be9', artist.id.uuid
    assert_equal Model::Artist::TYPE_PERSON, artist.type
    assert_equal 'Пётр Ильич Чайковский', artist.name
    assert_equal 'Tchaikovsky, Pyotr Ilyich', artist.sort_name
    assert_equal '1840-05-07', artist.begin_date.to_s
    assert_equal '1893-11-06', artist.end_date.to_s
    assert_equal 80, artist.aliases.size
  end
  
  def test_artist_tori_amos_1
    mbxml = Webservice::MBXML.new IO.read(DATA_PATH + 'artist/Tori_Amos_1.xml')
    artist = mbxml.get_entity(:artist)
    
    assert_equal 'c0b2500e-0cef-4130-869d-732b23ed9df5', artist.id.uuid
    assert_equal Model::Artist::TYPE_PERSON, artist.type
    assert_equal 'Tori Amos', artist.name
    assert_equal 'Amos, Tori', artist.sort_name
    assert_equal '1963-08-22', artist.begin_date.to_s
  end

  def test_artist_tori_amos_2
    mbxml = Webservice::MBXML.new IO.read(DATA_PATH + 'artist/Tori_Amos_2.xml')
    artist = mbxml.get_entity(:artist)
    
    assert_equal 'c0b2500e-0cef-4130-869d-732b23ed9df5', artist.id.uuid
    assert_equal Model::Artist::TYPE_PERSON, artist.type
    assert_equal 'Tori Amos', artist.name
    assert_equal 'Amos, Tori', artist.sort_name
    assert_equal '1963-08-22', artist.begin_date.to_s
    assert_equal 3, artist.releases.size
    assert_equal 'a7ccb022-f437-4492-8eee-8f85d85cdb96', artist.releases[0].id.uuid
    assert_equal artist, artist.releases[0].artist
    assert_equal '9cbf7040-dbdc-403c-940f-7562d9712514', artist.releases[1].id.uuid
    assert_equal artist, artist.releases[1].artist
    assert_equal '290e10c5-7efc-4f60-ba2c-0dfc0208fbf5', artist.releases[2].id.uuid
    assert_equal artist, artist.releases[2].artist
  end

  def test_artist_tori_amos_3
    mbxml = Webservice::MBXML.new IO.read(DATA_PATH + 'artist/Tori_Amos_3.xml')
    artist = mbxml.get_entity(:artist)
    
    assert_equal 'c0b2500e-0cef-4130-869d-732b23ed9df5', artist.id.uuid
    assert_equal Model::Artist::TYPE_PERSON, artist.type
    assert_equal 'Tori Amos', artist.name
    assert_equal 'Amos, Tori', artist.sort_name
    assert_equal '1963-08-22', artist.begin_date.to_s
    
    artist_rels = artist.get_relations(:target_type => Model::Relation::TO_ARTIST)
    assert_equal 1, artist_rels.size
    assert_equal Model::NS_REL_1 + 'Married', artist_rels[0].type
    assert_equal Model::Relation::DIR_BACKWARD, artist_rels[0].direction
    assert_equal Model::IncompleteDate.new('1998'), artist_rels[0].begin_date
    assert artist_rels[0].target.is_a?(Model::Artist)
    
    url_rels = artist.get_relations(:target_type => Model::Relation::TO_URL)
    assert_equal 2, url_rels.size
    assert_equal Model::NS_REL_1 + 'Discography', url_rels[0].type
    assert_equal 'http://www.yessaid.com/albums.html', url_rels[0].target
    assert_equal Model::NS_REL_1 + 'Wikipedia', url_rels[1].type
    assert_equal 'http://en.wikipedia.org/wiki/Tori_Amos', url_rels[1].target
  end

  def test_artist_tori_amos_4
    mbxml = Webservice::MBXML.new IO.read(DATA_PATH + 'artist/Tori_Amos_4.xml')
    artist = mbxml.get_entity(:artist)
    
    assert_equal 'c0b2500e-0cef-4130-869d-732b23ed9df5', artist.id.uuid
    assert_equal Model::Artist::TYPE_PERSON, artist.type
    assert_equal 'Tori Amos', artist.name
    assert_equal 'Amos, Tori', artist.sort_name
    assert_equal '1963-08-22', artist.begin_date.to_s
    assert_equal 3, artist.aliases.size
    assert_equal 'Myra Ellen Amos', artist.aliases[0].name
    assert_equal 'Latn', artist.aliases[0].script
    assert_equal 'Myra Amos', artist.aliases[1].name
    assert_equal 'Torie Amos', artist.aliases[2].name
    assert_equal 'Latn', artist.aliases[2].script
    assert_equal 'Misspelling', artist.aliases[2].type
  end

  def test_artist_tori_amos_5
    mbxml = Webservice::MBXML.new IO.read(DATA_PATH + 'artist/Tori_Amos_5.xml')
    artist = mbxml.get_entity(:artist)
    
    assert_equal 'c0b2500e-0cef-4130-869d-732b23ed9df5', artist.id.uuid
    assert_equal Model::Artist::TYPE_PERSON, artist.type
    assert_equal 'Tori Amos', artist.name
    assert_equal 'Amos, Tori', artist.sort_name
    assert_equal '1963-08-22', artist.begin_date.to_s
    assert_equal 1, artist.releases.size
    assert_equal 'a7ccb022-f437-4492-8eee-8f85d85cdb96', artist.releases[0].id.uuid
    assert_equal 'Strange Little Girls', artist.releases[0].title
    assert artist.releases[0].types.include?(Model::Release::TYPE_ALBUM)
    assert artist.releases[0].types.include?(Model::Release::TYPE_OFFICIAL)
  end

  def test_release_search
    mbxml = Webservice::MBXML.new IO.read(DATA_PATH + 'release/search_result_1.xml')
    assert_equal nil, mbxml.get_entity(:artist)
    assert_equal nil, mbxml.get_entity(:release)
    assert_equal nil, mbxml.get_entity(:track)
    assert_equal nil, mbxml.get_entity(:label)

    release_list = mbxml.get_entity_list(:release)
    assert_equal 0, release_list.offset
    assert_equal 234, release_list.count
    
    assert_equal 2, release_list.size, release_list.inspect
    assert_equal '290e10c5-7efc-4f60-ba2c-0dfc0208fbf5', release_list[0][:entity].id.uuid
    assert release_list[0][:entity].types.include?(Model::Release::TYPE_ALBUM)
    assert release_list[0][:entity].types.include?(Model::Release::TYPE_OFFICIAL)
    assert_equal 'Under the Pink', release_list[0][:entity].title
    assert_equal 'c0b2500e-0cef-4130-869d-732b23ed9df5', release_list[0][:entity].artist.id.uuid
    assert_equal 1, release_list[0][:entity].release_events.size
    assert_equal Model::IncompleteDate.new('1994-01-28'), release_list[0][:entity].release_events[0].date
    assert_equal 100, release_list[0][:score]
    assert_equal 80, release_list[1][:score]
  end
  
  def test_release_highway_61_revisited_1
    mbxml = Webservice::MBXML.new IO.read(DATA_PATH + 'release/Highway_61_Revisited_1.xml')
    release = mbxml.get_entity(:release)
    
    assert false, 'Test not implemented'
  end
  
  def test_release_little_earthquakes_1
    mbxml = Webservice::MBXML.new IO.read(DATA_PATH + 'release/Little_Earthquakes_1.xml')
    release = mbxml.get_entity(:release)
    
    assert_equal '02232360-337e-4a3f-ad20-6cdd4c34288c', release.id.uuid
    assert release.types.include?(Model::Release::TYPE_ALBUM)
    assert release.types.include?(Model::Release::TYPE_OFFICIAL)
    assert_equal 'Little Earthquakes', release.title
    assert_equal 'ENG', release.text_language
    assert_equal 'Latn', release.text_script
    assert_equal 'B000002IT2', release.asin
    assert_equal 'c0b2500e-0cef-4130-869d-732b23ed9df5', release.artist.id.uuid
    assert_equal 3, release.release_events.size
    assert_equal Model::IncompleteDate.new('1992-01-13'), release.release_events[0].date
    assert_equal 'GB', release.release_events[0].country
    assert_equal 3, release.discs.size
    assert_equal 'ILKp3.bZmvoMO7wSrq1cw7WatfA-', release.discs[0].id
  end

  def test_release_little_earthquakes_2
    mbxml = Webservice::MBXML.new IO.read(DATA_PATH + 'release/Little_Earthquakes_2.xml')
    release = mbxml.get_entity(:release)
    
    assert_equal '02232360-337e-4a3f-ad20-6cdd4c34288c', release.id.uuid
    assert release.types.include?(Model::Release::TYPE_ALBUM)
    assert release.types.include?(Model::Release::TYPE_OFFICIAL)
    assert_equal 'Little Earthquakes', release.title
    assert_equal 'ENG', release.text_language
    assert_equal 'Latn', release.text_script
    assert_equal 'B000002IT2', release.asin
    assert_equal 'c0b2500e-0cef-4130-869d-732b23ed9df5', release.artist.id.uuid
    assert_equal 3, release.release_events.size
    assert_equal Model::IncompleteDate.new('1992-01-13'), release.release_events[0].date
    assert_equal 'GB', release.release_events[0].country
    assert_equal 3, release.discs.size
    assert_equal 'ILKp3.bZmvoMO7wSrq1cw7WatfA-', release.discs[0].id
    assert_equal 12, release.tracks.size
    assert_equal '6e71c125-3cb5-4a19-a1f0-66779c9ae9f4', release.tracks[0].id.uuid
    assert_equal 'Crucify', release.tracks[0].title
    assert_equal 301186, release.tracks[0].duration
  end

  # This is a various artist release.
  def test_release_mission_impossible_2
    mbxml = Webservice::MBXML.new IO.read(DATA_PATH + 'release/Mission_Impossible_2.xml')
    release = mbxml.get_entity(:release)
    
    assert_equal '81683d13-e014-4d35-9774-6f536f4ef557', release.id.uuid
    assert release.types.include?(Model::Release::TYPE_SOUNDTRACK)
    assert release.types.include?(Model::Release::TYPE_OFFICIAL)
    assert_equal 'Mission: Impossible 2', release.title
    assert_equal 'ENG', release.text_language
    assert_equal 'Latn', release.text_script
    assert_equal '89ad4ac3-39f7-470e-963a-56509c546377', release.artist.id.uuid
    assert_equal 1, release.release_events.size
    assert_equal Model::IncompleteDate.new('2000'), release.release_events[0].date
    assert_equal 'EU', release.release_events[0].country
    assert_equal 16, release.tracks.size
    release.tracks.each {|track|
      assert_not_equal release.artist, track.artist
    }
  end

  def test_release_under_the_pink_1
    mbxml = Webservice::MBXML.new IO.read(DATA_PATH + 'release/Under_the_Pink_1.xml')
    release = mbxml.get_entity(:release)
    
    assert false, 'Test not implemented'
  end

  def test_release_under_the_pink_2
    mbxml = Webservice::MBXML.new IO.read(DATA_PATH + 'release/Under_the_Pink_2.xml')
    release = mbxml.get_entity(:release)
    
    assert false, 'Test not implemented'
  end

  def test_release_under_the_pink_3
    mbxml = Webservice::MBXML.new IO.read(DATA_PATH + 'release/Under_the_Pink_3.xml')
    release = mbxml.get_entity(:release)
    
    assert false, 'Test not implemented'
  end

  def test_track_search
    mbxml = Webservice::MBXML.new IO.read(DATA_PATH + 'track/search_result_1.xml')
    assert_equal nil, mbxml.get_entity(:artist)
    assert_equal nil, mbxml.get_entity(:release)
    assert_equal nil, mbxml.get_entity(:track)
    assert_equal nil, mbxml.get_entity(:label)

    track_list = mbxml.get_entity_list(:track)
    assert_equal 7, track_list.offset
    assert_equal 100, track_list.count
    
    assert_equal 3, track_list.size, track_list.inspect
    assert_equal '748f2b79-8c50-4581-adb1-7708118a48fc', track_list[0][:entity].id.uuid
    assert_equal 'Little Earthquakes', track_list[0][:entity].title
    assert_equal 457760, track_list[0][:entity].duration
    assert_equal 'c0b2500e-0cef-4130-869d-732b23ed9df5', track_list[0][:entity].artist.id.uuid
    assert_equal 1, track_list[0][:entity].releases.size
    assert_equal '93264fe5-dff2-47ab-9ca8-1c865733aad9', track_list[0][:entity].releases[0].id.uuid
    assert_equal 100, track_list[0][:score]
    assert_equal 99, track_list[1][:score]
    assert_equal 80, track_list[2][:score]
  end
  
  def test_track_silent_all_these_years_1
    mbxml = Webservice::MBXML.new IO.read(DATA_PATH + 'track/Silent_All_These_Years_1.xml')
    track = mbxml.get_entity(:track)
    
    assert_equal 'd6118046-407d-4e06-a1ba-49c399a4c42f', track.id.uuid
    assert_equal 'Silent All These Years', track.title
    assert_equal 253466, track.duration
  end

  def test_track_silent_all_these_years_2
    mbxml = Webservice::MBXML.new IO.read(DATA_PATH + 'track/Silent_All_These_Years_2.xml')
    track = mbxml.get_entity(:track)
    
    assert_equal 'd6118046-407d-4e06-a1ba-49c399a4c42f', track.id.uuid
    assert_equal 'Silent All These Years', track.title
    assert_equal 253466, track.duration
    assert_equal 'c0b2500e-0cef-4130-869d-732b23ed9df5', track.artist.id.uuid
    
    track_rels = track.get_relations(:target_type => Model::Relation::TO_TRACK)
    assert_equal 1, track_rels.size, track.get_relations.inspect
    assert_equal Model::NS_REL_1 + 'Cover', track_rels[0].type
    assert_equal Model::Relation::DIR_BACKWARD, track_rels[0].direction
    assert track_rels[0].target.is_a?(Model::Track)
    assert_equal '5bcd4eaa-fae7-465f-9f03-d005b959ed02', track_rels[0].target.artist.id.uuid
  end

  def test_track_silent_all_these_years_3
    mbxml = Webservice::MBXML.new IO.read(DATA_PATH + 'track/Silent_All_These_Years_3.xml')
    track = mbxml.get_entity(:track)
    
    assert_equal 'd6118046-407d-4e06-a1ba-49c399a4c42f', track.id.uuid
    assert_equal 'Silent All These Years', track.title
    assert_equal 253466, track.duration
    assert_equal 7, track.puids.size
    assert_equal 'c2a2cee5-a8ca-4f89-a092-c3e1e65ab7e6', track.puids[0]
    assert_equal '42ab76ea-5d42-4259-85d7-e7f2c69e4485', track.puids[6]
  end

  def test_track_silent_all_these_years_4
    mbxml = Webservice::MBXML.new IO.read(DATA_PATH + 'track/Silent_All_These_Years_4.xml')
    track = mbxml.get_entity(:track)
    
    assert_equal 'd6118046-407d-4e06-a1ba-49c399a4c42f', track.id.uuid
    assert_equal 'Silent All These Years', track.title
    assert_equal 253466, track.duration
    assert_equal 'c0b2500e-0cef-4130-869d-732b23ed9df5', track.artist.id.uuid
    assert_equal 1, track.releases.size
    assert_equal '02232360-337e-4a3f-ad20-6cdd4c34288c', track.releases[0].id.uuid
    assert_equal 7, track.puids.size
    assert_equal 'c2a2cee5-a8ca-4f89-a092-c3e1e65ab7e6', track.puids[0]
    assert_equal '42ab76ea-5d42-4259-85d7-e7f2c69e4485', track.puids[6]
  end

  # This test is similiar to silent_all_these_years_3, but it includes an
  # schema exctension which mustn't disturb the parsing.
  def test_track_silent_all_these_years_5
    mbxml = Webservice::MBXML.new IO.read(DATA_PATH + 'track/Silent_All_These_Years_5.xml')
    track = mbxml.get_entity(:track)
    
    assert_equal 'd6118046-407d-4e06-a1ba-49c399a4c42f', track.id.uuid
    assert_equal 'Silent All These Years', track.title
    assert_equal 253466, track.duration
    assert_equal 7, track.puids.size
    assert_equal 'c2a2cee5-a8ca-4f89-a092-c3e1e65ab7e6', track.puids[0]
    assert_equal '42ab76ea-5d42-4259-85d7-e7f2c69e4485', track.puids[6]
  end

  def test_label_search
    mbxml = Webservice::MBXML.new IO.read(DATA_PATH + 'label/search_result_1.xml')
    assert_equal nil, mbxml.get_entity(:artist)
    assert_equal nil, mbxml.get_entity(:release)
    assert_equal nil, mbxml.get_entity(:track)
    assert_equal nil, mbxml.get_entity(:label)

    label_list = mbxml.get_entity_list(:label)
    assert_equal 0, label_list.offset
    assert_equal 2, label_list.count
    
    assert_equal 2, label_list.size, label_list.inspect
    assert_equal '50c384a2-0b44-401b-b893-8181173339c7', label_list[0][:entity].id.uuid
    assert_equal Model::Label::TYPE_ORIGINAL_PRODUCTION, label_list[0][:entity].type
    assert_equal 'Atlantic Records', label_list[0][:entity].name
    assert_equal 'US', label_list[0][:entity].country
    assert_equal 100, label_list[0][:score]
    assert_equal 'c2ccaec8-0dfe-4dd5-a710-bddf5fd7c1a7', label_list[1][:entity].id.uuid
    assert_equal nil, label_list[1][:entity].type
    assert_equal 'DRO Atlantic', label_list[1][:entity].name
    assert_equal 'SP', label_list[1][:entity].country
    assert_equal 46, label_list[1][:score]
  end
  
  def test_label_atlantic_records_1
    mbxml = Webservice::MBXML.new IO.read(DATA_PATH + 'label/Atlantic_Records_1.xml')
    label = mbxml.get_entity(:label)
    
    assert_equal '50c384a2-0b44-401b-b893-8181173339c7', label.id.uuid
    assert_equal Model::Label::TYPE_ORIGINAL_PRODUCTION, label.type
    assert_equal 'Atlantic Records', label.name
    assert_equal '121', label.code
    assert_equal 'US', label.country
    assert_equal '1947', label.begin_date.to_s
  end

  def test_label_atlantic_records_2
    mbxml = Webservice::MBXML.new IO.read(DATA_PATH + 'label/Atlantic_Records_2.xml')
    label = mbxml.get_entity(:label)
    
    assert_equal Model::Label::TYPE_DISTRIBUTOR, label.type
    assert_equal 'Atlantic Records', label.name
    assert_equal 'AR SortName', label.sort_name
    assert_equal '121', label.code
    assert_equal 'fake', label.disambiguation
    assert_equal 'US', label.country
    assert_equal '1947', label.begin_date.to_s
    assert_equal '2047', label.end_date.to_s
    assert_equal 1, label.aliases.size
    assert_equal 'Atlantic Rec.', label.aliases[0].name
  end

  def test_user_1
    mbxml = Webservice::MBXML.new IO.read(DATA_PATH + 'user/User_1.xml')
    users = mbxml.get_entity_array(:user, Model::NS_EXT_1)
    
    assert_equal 1, users.size
    assert_equal 'matt', users[0].name
    assert_equal false, users[0].show_nag?
    assert_equal 2, users[0].types.size
    assert_equal Model::NS_EXT_1 + 'AutoEditor', users[0].types[0]
    assert_equal Model::NS_EXT_1 + 'RelationshipEditor', users[0].types[1]
  end
end
