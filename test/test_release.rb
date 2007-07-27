# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'test_entity'

# Unit test for the Release model.
class TestRelease < Test::Unit::TestCase

  def setup
    @tested_class = Model::Release
    @invalid_entity_types = [:artist, :track, :label]
    @tracks = [Model::Track.new, Model::Track.new]
    @release_events = [Model::ReleaseEvent.new('DE', 2007), Model::ReleaseEvent.new('GB', 1996)]
    @discs = [Model::Disc.new, Model::Disc.new]
  end

  def teardown
  end
  
  # Include the tests for Entity
  include TestEntity

  def test_new_release
    release = nil
    assert_nothing_raised {release = Model::Release.new}
    assert release.is_a?(Model::Entity)
    
    mbid = Model::MBID.new('9d30e408-1559-448b-b491-2f8de1583ccf', release.entity_type)
    assert_nothing_raised {release = Model::Release.new(
      mbid,
      'Draconian Times'
      )}
    assert_equal mbid, release.id
    assert_equal 'Draconian Times', release.title
  end
  
  def test_title
    release = Model::Release.new
    assert release.title.nil?
    assert_nothing_raised {release.title = 'Draconian Times'}
    assert_equal 'Draconian Times', release.title
    assert_equal 'Draconian Times', release.to_s
  end

  def test_asin
    release = Model::Release.new
    assert release.asin.nil?
    assert_nothing_raised {release.asin = 'B000024IXL'}
    assert_equal 'B000024IXL', release.asin
  end
 
  def test_artist
    release = Model::Release.new
    artist = Model::Artist.new
    assert release.artist.nil?
    assert_nothing_raised {release.artist = artist}
    assert_equal artist, release.artist
  end

  def test_text_language
    release = Model::Release.new
    assert release.text_language.nil?
    assert_nothing_raised {release.text_language = 'ENG'}
    assert_equal 'ENG', release.text_language
  end

  def test_text_script
    release = Model::Release.new
    assert release.text_script.nil?
    assert_nothing_raised {release.text_script = 'Latn'}
    assert_equal 'Latn', release.text_script
  end
  
  def test_types
    release = Model::Release.new
    assert_equal 0, release.types.size
    types = []
    assert_nothing_raised {
      types = [Model::Release::TYPE_ALBUM,      Model::Release::TYPE_AUDIOBOOK,
               Model::Release::TYPE_BOOTLEG,    Model::Release::TYPE_COMPILATION,
               Model::Release::TYPE_EP,         Model::Release::TYPE_INTERVIEW,
               Model::Release::TYPE_LIVE,       Model::Release::TYPE_NONE,
               Model::Release::TYPE_OFFICIAL,   Model::Release::TYPE_OTHER,
               Model::Release::TYPE_PROMOTION,  Model::Release::TYPE_PSEUDO_RELEASE,
               Model::Release::TYPE_REMIX,      Model::Release::TYPE_SINGLE,
               Model::Release::TYPE_SOUNDTRACK, Model::Release::TYPE_SPOKENWORD]
    }
    
    # Adding all those types should be possible.
    types.each {|type|
      assert_nothing_raised {release.types << type}
    }
    assert_equal 16, release.types.size
    
    # Removing the types again
    types.each {|type|
      assert_nothing_raised {release.types.delete type}
    }
    assert_equal 0, release.types.size
  end

  # Many tracks can be added
  def test_add_and_remove_tracks
    release = Model::Release.new
    assert_equal 0, release.tracks.size
    assert_nothing_raised {release.tracks << @tracks[0]}
    assert_equal 1, release.tracks.size
    assert_nothing_raised {release.tracks << @tracks[1]}
    assert_equal 2, release.tracks.size
    
    assert_nothing_raised {release.tracks.delete @tracks[1]}
    assert_equal 1, release.tracks.size
    assert_nothing_raised {release.tracks.delete @tracks[0]}
    assert_equal 0, release.tracks.size
  end
  
  # Many release events can be added
  def test_add_and_remove_release_events
    release = Model::Release.new
    
    assert_equal nil, release.earliest_release_event
    assert_equal nil, release.earliest_release_date
    
    assert_equal 0, release.release_events.size
    assert_nothing_raised {release.release_events << @release_events[0]}
    assert_equal 1, release.release_events.size
    assert_nothing_raised {release.release_events << @release_events[1]}
    assert_equal 2, release.release_events.size
    
    assert_equal @release_events[1], release.earliest_release_event
    assert_equal release.earliest_release_event.date, release.earliest_release_date
    
    assert_nothing_raised {release.release_events.delete @release_events[1]}
    assert_equal 1, release.release_events.size
    assert_nothing_raised {release.release_events.delete @release_events[0]}
    assert_equal 0, release.release_events.size
  end
  
  # Many discs can be added
  def test_add_and_remove_disc
    release = Model::Release.new
    assert_equal 0, release.discs.size
    assert_nothing_raised {release.discs << @discs[0]}
    assert_equal 1, release.discs.size
    assert_nothing_raised {release.discs << @discs[1]}
    assert_equal 2, release.discs.size
    
    assert_nothing_raised {release.discs.delete @discs[1]}
    assert_equal 1, release.discs.size
    assert_nothing_raised {release.discs.delete @discs[0]}
    assert_equal 0, release.discs.size
  end
  
end
