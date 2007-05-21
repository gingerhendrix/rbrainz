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
    assert_equal Model::Artist::TYPES[:Person], artist_list[0].type
    assert_equal 'Tori Amos', artist_list[0].name
    assert_equal 'Amos, Tori', artist_list[0].sort_name
    assert_equal '1963-08-22', artist_list[0].begin_date.to_s
  end
  
  def test_artist_tchaikovsky_1
    mbxml = Webservice::MBXML.new IO.read(DATA_PATH + 'artist/Tchaikovsky-1.xml')
    artist = mbxml.get_entity(:artist)
    
    assert_equal '9ddd7abc-9e1b-471d-8031-583bc6bc8be9', artist.id.uuid
    assert_equal Model::Artist::TYPES[:Person], artist.type
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
    assert_equal Model::Artist::TYPES[:Person], artist.type
    assert_equal 'Tori Amos', artist.name
    assert_equal 'Amos, Tori', artist.sort_name
    assert_equal '1963-08-22', artist.begin_date.to_s
  end

  def test_artist_tori_amos_2
    mbxml = Webservice::MBXML.new IO.read(DATA_PATH + 'artist/Tori_Amos_2.xml')
    artist = mbxml.get_entity(:artist)
    
    assert_equal 'c0b2500e-0cef-4130-869d-732b23ed9df5', artist.id.uuid
    assert_equal Model::Artist::TYPES[:Person], artist.type
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
    assert_equal Model::Artist::TYPES[:Person], artist.type
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
    assert_equal Model::Artist::TYPES[:Person], artist.type
    assert_equal 'Tori Amos', artist.name
    assert_equal 'Amos, Tori', artist.sort_name
    assert_equal '1963-08-22', artist.begin_date.to_s
    assert_equal 1, artist.releases.size
    assert_equal 'a7ccb022-f437-4492-8eee-8f85d85cdb96', artist.releases[0].id.uuid
    assert_equal 'Strange Little Girls', artist.releases[0].title
    assert artist.releases[0].type_list.include?('Album')
    assert artist.releases[0].type_list.include?('Official')
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
    assert false, 'Test not implemented'
  end
  
  def test_track_silent_all_these_years_1
    mbxml = Webservice::MBXML.new IO.read(DATA_PATH + 'track/Silent_All_These_Years_1.xml')
    release = mbxml.get_entity(:track)
    
    assert false, 'Test not implemented'
  end

  def test_track_silent_all_these_years_2
    mbxml = Webservice::MBXML.new IO.read(DATA_PATH + 'track/Silent_All_These_Years_2.xml')
    release = mbxml.get_entity(:track)
    
    assert false, 'Test not implemented'
  end

  def test_track_silent_all_these_years_3
    mbxml = Webservice::MBXML.new IO.read(DATA_PATH + 'track/Silent_All_These_Years_3.xml')
    release = mbxml.get_entity(:track)
    
    assert false, 'Test not implemented'
  end

  def test_track_silent_all_these_years_4
    mbxml = Webservice::MBXML.new IO.read(DATA_PATH + 'track/Silent_All_These_Years_4.xml')
    release = mbxml.get_entity(:track)
    
    assert false, 'Test not implemented'
  end

  def test_track_silent_all_these_years_5
    mbxml = Webservice::MBXML.new IO.read(DATA_PATH + 'track/Silent_All_These_Years_5.xml')
    release = mbxml.get_entity(:track)
    
    assert false, 'Test not implemented'
  end

  def test_label_search
    assert false, 'Test not implemented'
  end
  
  def test_label_atlantic_records_1
    mbxml = Webservice::MBXML.new IO.read(DATA_PATH + 'label/Atlantic_Records_1.xml')
    release = mbxml.get_entity(:label)
    
    assert false, 'Test not implemented'
  end

  def test_label_atlantic_records_2
    mbxml = Webservice::MBXML.new IO.read(DATA_PATH + 'label/Atlantic_Records_2.xml')
    release = mbxml.get_entity(:label)
    
    assert false, 'Test not implemented'
  end

end
