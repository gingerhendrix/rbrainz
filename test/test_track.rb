# $Id$
# Copyright (c) 2007, Philipp Wolfer
# All rights reserved.
# See LICENSE for permissions.

require 'test_entity'

# Unit test for the Track model.
class TestTrack < Test::Unit::TestCase

  def setup
    @tested_class = Model::Track
    @invalid_entity_types = [:artist, :release, :label]
  
    @artist = Model::Artist.new
    @valid_puids = ['9d30e408-1559-448b-b491-2f8de1583ccf',
                    '727ad90b-7ef4-48d2-8f16-c34016544822']
    @releases = [Model::Release.new, Model::Release.new]
  end

  def teardown
  end
  
  # Include the tests for Entity
  include TestEntity

  def test_new_track
    track = nil
    assert_nothing_raised {track = Model::Track.new}
    assert track.is_a?(Model::Entity)
  end
  
  def test_title
    track = Model::Track.new
    assert track.title.nil?
    assert_nothing_raised {track.title = 'Indifferent Suns'}
    assert_equal 'Indifferent Suns', track.title
  end
  
  # Duration is given in milliseconds.
  # It must be a positive integer or nil for unknown.
  def test_duration
    track = Model::Track.new
    assert track.duration.nil?
    assert_nothing_raised {track.duration = 215800}
    assert_equal 215800, track.duration
  end
  
  def test_artist
    track = Model::Track.new
    assert track.artist.nil?
    assert_nothing_raised {track.artist = @artist}
    assert_equal @artist, track.artist
    assert_nothing_raised {track.artist = nil}
    assert_equal nil, track.artist
  end
  
  # Many PUIDs can be added
  def test_add_and_remove_puids
    track = Model::Track.new
    assert_equal 0, track.puids.size
    assert_nothing_raised {track.puids << @valid_puids[0]}
    assert_equal 1, track.puids.size
    assert_nothing_raised {track.puids << @valid_puids[1]}
    assert_equal 2, track.puids.size
    # Re-adding an already existing PUID should not lead to duplicates
    assert_nothing_raised {track.puids << @valid_puids[1]}
    assert_equal 2, track.puids.size
    assert_nothing_raised {track.puids.delete @valid_puids[1]}
    assert_equal 1, track.puids.size
    assert_nothing_raised {track.puids.delete @valid_puids[0]}
    assert_equal 0, track.puids.size
  end
  
  # You can pass an array of PUIDs to add them all.
  def test_add_several_puids_at_once
    track = Model::Track.new
    assert_nothing_raised {track.puids = @valid_puids}
    assert_equal @valid_puids, track.puids
  end
  
  # Many releases can be added
  def test_add_and_remove_releases
    track = Model::Track.new
    assert_equal 0, track.releases.size
    assert_nothing_raised {track.releases << @releases[0]}
    assert_equal 1, track.releases.size
    assert_nothing_raised {track.releases << @releases[1]}
    assert_equal 2, track.releases.size
    # Re-adding an already existing release should not lead to duplicates
    assert_nothing_raised {track.releases << @releases[1]}
    assert_equal 2, track.releases.size
    assert_nothing_raised {track.releases.delete @releases[1]}
    assert_equal 1, track.releases.size
    assert_nothing_raised {track.releases.delete @releases[0]}
    assert_equal 0, track.releases.size
  end
  
  # You can pass an array of releases to add them all.
  def test_add_several_releases_at_once
    track = Model::Track.new
    assert_nothing_raised {track.releases = @releases}
    assert_equal @releases, track.releases
  end
  
end
