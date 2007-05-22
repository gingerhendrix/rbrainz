# $Id$
# Copyright (c) 2007, Philipp Wolfer
# All rights reserved.
# See LICENSE for permissions.

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
    assert_equal Array.new, mbxml.get_entity_list(:artist)
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
    assert_equal 3, artist_list.size, artist_list.inspect
    assert_equal 'c0b2500e-0cef-4130-869d-732b23ed9df5', artist_list[0].id.uuid
    assert_equal Model::Artist::TYPE_PERSON, artist_list[0].type
    assert_equal 'Tori Amos', artist_list[0].name
    assert_equal 'Amos, Tori', artist_list[0].sort_name
    assert_equal '1963-08-22', artist_list[0].begin_date.to_s
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
    
    assert false, 'Test not implemented'
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
    assert false, 'Test not implemented'
  end
  
  def test_release_highway_61_revisited_1
    mbxml = Webservice::MBXML.new IO.read(DATA_PATH + 'release/Highway_61_Revisited_1.xml')
    release = mbxml.get_entity(:release)
    
    assert false, 'Test not implemented'
  end
  
  def test_release_little_earthquakes_1
    mbxml = Webservice::MBXML.new IO.read(DATA_PATH + 'release/Little_Earthquakes_1.xml')
    release = mbxml.get_entity(:release)
    
    assert false, 'Test not implemented'
  end

  def test_release_little_earthquakes_2
    mbxml = Webservice::MBXML.new IO.read(DATA_PATH + 'release/Little_Earthquakes_2.xml')
    release = mbxml.get_entity(:release)
    
    assert false, 'Test not implemented'
  end

  def test_release_mission_impossible_2
    mbxml = Webservice::MBXML.new IO.read(DATA_PATH + 'release/Mission_Impossible_2.xml')
    release = mbxml.get_entity(:release)
    
    assert false, 'Test not implemented'
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
    assert_equal 3, track_list.size, track_list.inspect
    assert_equal '748f2b79-8c50-4581-adb1-7708118a48fc', track_list[0].id.uuid
    assert_equal 'Little Earthquakes', track_list[0].title
    assert_equal 457760, track_list[0].duration
    assert_equal 'c0b2500e-0cef-4130-869d-732b23ed9df5', track_list[0].artist.id.uuid
    assert_equal 1, track_list[0].releases.size
    assert_equal '93264fe5-dff2-47ab-9ca8-1c865733aad9', track_list[0].releases[0].id.uuid
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
    
    assert false, 'Test not implemented'
  end

  def test_track_silent_all_these_years_3
    mbxml = Webservice::MBXML.new IO.read(DATA_PATH + 'track/Silent_All_These_Years_3.xml')
    track = mbxml.get_entity(:track)
    
    assert_equal 'd6118046-407d-4e06-a1ba-49c399a4c42f', track.id.uuid
    assert_equal 'Silent All These Years', track.title
    assert_equal 253466, track.duration
    assert_equal 7, track.puids.size
    assert_equal 'c2a2cee5-a8ca-4f89-a092-c3e1e65ab7e6', track.puids[0].id.uuid
    assert_equal '42ab76ea-5d42-4259-85d7-e7f2c69e4485', track.puids[6].id.uuid
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
    assert_equal 'c2a2cee5-a8ca-4f89-a092-c3e1e65ab7e6', track.puids[0].id.uuid
    assert_equal '42ab76ea-5d42-4259-85d7-e7f2c69e4485', track.puids[6].id.uuid
  end

  def test_track_silent_all_these_years_5
    mbxml = Webservice::MBXML.new IO.read(DATA_PATH + 'track/Silent_All_These_Years_5.xml')
    track = mbxml.get_entity(:track)
    
    assert false, 'Test not implemented'
  end

  def test_label_search
    mbxml = Webservice::MBXML.new IO.read(DATA_PATH + 'label/search_result_1.xml')
    assert_equal nil, mbxml.get_entity(:artist)
    assert_equal nil, mbxml.get_entity(:release)
    assert_equal nil, mbxml.get_entity(:track)
    assert_equal nil, mbxml.get_entity(:label)

    label_list = mbxml.get_entity_list(:label)
    assert_equal 2, label_list.size, label_list.inspect
    assert_equal '50c384a2-0b44-401b-b893-8181173339c7', label_list[0].id.uuid
    assert_equal Model::Label::TYPE_ORIGINAL_PRODUCTION, label_list[0].type
    assert_equal 'Atlantic Records', label_list[0].name
    assert_equal 'US', label_list[0].country
    assert_equal 'c2ccaec8-0dfe-4dd5-a710-bddf5fd7c1a7', label_list[1].id.uuid
    assert_equal nil, label_list[1].type
    assert_equal 'DRO Atlantic', label_list[1].name
    assert_equal 'SP', label_list[1].country
  end
  
  def test_label_atlantic_records_1
    mbxml = Webservice::MBXML.new IO.read(DATA_PATH + 'label/Atlantic_Records_1.xml')
    label = mbxml.get_entity(:label)
    
    assert_equal '50c384a2-0b44-401b-b893-8181173339c7', label.id.uuid
    assert_equal Model::Label::TYPE_ORIGINAL_PRODUCTION, label.type
    assert_equal 'Atlantic Records', label.name
    assert_equal '121', label.code
    assert_equal 'US', label.country
    assert_equal '1947', label.founding_date.to_s
  end

  def test_label_atlantic_records_2
    mbxml = Webservice::MBXML.new IO.read(DATA_PATH + 'label/Atlantic_Records_2.xml')
    label = mbxml.get_entity(:label)
    
    assert_equal Model::Label::TYPE_DISTRIBUTOR, label.type
    assert_equal 'Atlantic Records', label.name
    assert_equal 'AR SortName', label.name
    assert_equal '121', label.code
    assert_equal 'fake', label.disambiguation
    assert_equal 'US', label.country
    assert_equal '1947', label.founding_date.to_s
    assert_equal '2047', label.dissolving_date.to_s
  end

end
