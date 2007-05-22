# $Id$
# Copyright (c) 2007, Philipp Wolfer
# All rights reserved.
# See LICENSE for permissions.

require 'test_entity'

# Unit test for the Artist model.
class TestArtist < Test::Unit::TestCase

  def setup
    @tested_class = Model::Artist
    @invalid_entity_types = [:release, :track, :label]
    @releases = [Model::Release.new, Model::Release.new]
    @aliases = [Model::Alias.new, Model::Alias.new]
  end

  def teardown
  end
  
  # Include the tests for Entity
  include TestEntity

  def test_new_artist
    artist = nil
    assert_nothing_raised {artist = Model::Artist.new}
    assert artist.is_a?(Model::Entity)
  end
  
  def test_name
    artist = Model::Artist.new
    assert artist.name.nil?
    assert_nothing_raised {artist.name = 'Paradise Lost'}
    assert_equal 'Paradise Lost', artist.name
  end
  
  def test_sort_name
    artist = Model::Artist.new
    assert artist.sort_name.nil?
    assert_nothing_raised {artist.sort_name = 'Paradise Lost'}
    assert_equal 'Paradise Lost', artist.sort_name
  end
  
  def test_disambiguation
    artist = Model::Artist.new
    assert artist.disambiguation.nil?
    assert_nothing_raised {artist.disambiguation = 'Disambiguation comment'}
    assert_equal 'Disambiguation comment', artist.disambiguation
  end
  
  def test_type
    artist = Model::Artist.new
    assert artist.type.nil?
    assert_nothing_raised {artist.type = Model::Artist::TYPE_PERSON}
    assert_equal Model::Artist::TYPE_PERSON, artist.type
    assert_nothing_raised {artist.type = Model::Artist::TYPE_GROUP}
    assert_equal Model::Artist::TYPE_GROUP, artist.type
  end

  def test_begin_date
    artist = Model::Artist.new
    date = Model::IncompleteDate.new '1988-04-18'
    assert_nothing_raised {artist.begin_date}
    assert_equal nil, artist.begin_date
    assert_nothing_raised {artist.begin_date = date}
    assert_equal date, artist.begin_date
    
    # It should be able to supply a date as a string,
    # but Artist should convert it to an IncompleteDate.
    assert_nothing_raised {artist.begin_date = '1988-04-20'}
    assert_equal Model::IncompleteDate.new('1988-04-20'), artist.begin_date
  end

  def test_end_date
    artist = Model::Artist.new
    date = Model::IncompleteDate.new '1988-04-18'
    assert_nothing_raised {artist.end_date}
    assert_equal nil, artist.end_date
    assert_nothing_raised {artist.end_date = date}
    assert_equal date, artist.end_date
    
    # It should be able to supply a date as a string,
    # but Artist should convert it to an IncompleteDate.
    assert_nothing_raised {artist.end_date = '1988-04-20'}
    assert_equal Model::IncompleteDate.new('1988-04-20'), artist.end_date
  end

  # Many releases can be added
  def test_add_and_remove_releases
    artist = Model::Artist.new
    assert_equal 0, artist.releases.size
    assert_nothing_raised {artist.releases << @releases[0]}
    assert_equal 1, artist.releases.size
    assert_nothing_raised {artist.releases << @releases[1]}
    assert_equal 2, artist.releases.size
    # Re-adding an already existing release should not lead to duplicates
    assert_nothing_raised {artist.releases << @releases[1]}
    assert_equal 2, artist.releases.size
    assert_nothing_raised {artist.releases.delete @releases[1]}
    assert_equal 1, artist.releases.size
    assert_nothing_raised {artist.releases.delete @releases[0]}
    assert_equal 0, artist.releases.size
  end
  
  # You can pass an array of releases to add them all.
  def test_add_several_releases_at_once
    artist = Model::Artist.new
    assert_nothing_raised {artist.releases = @releases}
    assert_equal @releases, artist.releases
  end
 
  # Many aliases can be added
  def test_add_and_remove_releases
    artist = Model::Artist.new
    assert_equal 0, artist.aliases.size
    assert_nothing_raised {artist.aliases << @aliases[0]}
    assert_equal 1, artist.aliases.size
    assert_nothing_raised {artist.aliases << @aliases[1]}
    assert_equal 2, artist.aliases.size
    # Re-adding an already existing alias should not lead to duplicates
    assert_nothing_raised {artist.aliases << @aliases[1]}
    assert_equal 2, artist.aliases.size
    assert_nothing_raised {artist.aliases.delete @aliases[1]}
    assert_equal 1, artist.aliases.size
    assert_nothing_raised {artist.aliases.delete @aliases[0]}
    assert_equal 0, artist.aliases.size
  end
  
  # You can pass an array of aliases to add them all.
  def test_add_several_releases_at_once
    artist = Model::Artist.new
    assert_nothing_raised {artist.aliases = @aliases}
    assert_equal @aliases, artist.aliases
  end
 
end
