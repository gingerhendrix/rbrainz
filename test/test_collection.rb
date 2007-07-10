# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

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
    collection = Webservice::Collection.new(102, 8)
    assert_equal 102, collection.count
    assert_equal 8, collection.offset
    
    assert collection.empty?
    
    # Fill the collection
    assert_nothing_raised {
      collection << [@artist_one, 100]
      collection << [@artist_two,  98]
      # The score can be ignored
      collection << @artist_three
    }
    assert_equal 3, collection.size
    assert !collection.empty?
    
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
    assert_equal @artist_one, collection[0][:entity]
    assert_equal 100, collection[0][:score]
    assert_equal @artist_two, collection[1][:entity]
    assert_equal 98, collection[1][:score]
    assert_equal @artist_three, collection[2][:entity]
    assert_equal nil, collection[2][:score]
    
    # Convert collection to array
    array = collection.to_a
    assert_equal @artist_one, array[0][:entity]
    assert_equal 100, array[0][:score]
    assert_equal @artist_two, array[1][:entity]
    assert_equal 98, array[1][:score]
    assert_equal @artist_three, array[2][:entity]
    assert_equal nil, array[2][:score]
    
    # Access the entities as an array
    assert_equal @artist_one, collection.entities[0]
    assert_equal @artist_two, collection.entities[1]
    assert_equal @artist_three, collection.entities[2]
  end

end