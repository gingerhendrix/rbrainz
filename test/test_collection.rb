# $Id$
# Copyright (c) 2007, Philipp Wolfer
# All rights reserved.
# See LICENSE for permissions.

require 'test/unit'
require 'rbrainz'
include MusicBrainz

# Unit test for the Collection class.
class TestCollection < Test::Unit::TestCase

  def setup
    @artist_one   = Model::Artist.new
    @artist_two   = Model::Artist.new
    @artist_three = Model::Artist.new
  end

  def teardown
  end
  
  def test_collection
    collection = Webservice::Collection.new
    
    # Fill the collection
    assert_nothing_raised {
      collection << [@artist_one, 100]
      collection << [@artist_two,  98]
      # The score can be ignored
      collection << @artist_three
    }
    assert_equal 3, collection.size
    
    # Iterate over the collection
    n = 0
    collection.each {|artist, score|
      assert artist.is_a?(Model::Artist), artist.inspect
      assert((score.is_a?(Integer) or score.nil?), score.inspect)
      n += 1
    }
    assert_equal collection.size, n
    
    # Iterate over the artists only, ignoring the scores
    n = 0
    collection.each_entity {|artist|
      assert artist.is_a?(Model::Artist), artist.inspect
      n += 1
    }
    assert_equal collection.size, n
    
    # Random access
    assert_equal @artist_one, collection[0].first
    assert_equal 100, collection[0].last
    assert_equal @artist_two, collection[1].first
    assert_equal 98, collection[1].last
    assert_equal @artist_three, collection[2].first
    assert_equal nil, collection[2].last
  end

end