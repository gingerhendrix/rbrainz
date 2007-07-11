# $Id: test_collection.rb 114 2007-07-10 19:33:22Z phw $
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'test/unit'
require 'rbrainz'
include MusicBrainz

# Unit test for the Collection class.
class TestScoredCollection < Test::Unit::TestCase

  def setup
    @artist_one   = Model::Artist.new
    @artist_two   = Model::Artist.new
    @artist_three = Model::Artist.new
  end

  def teardown
  end
  
  def test_scored_collection
    collection = Model::ScoredCollection.new(102, 8)
    assert_equal 102, collection.count
    assert_equal 8, collection.offset
    
    collection.count = 99
    collection.offset=15
    assert_equal 99, collection.count
    assert_equal 15, collection.offset
    
    assert collection.empty?
    
    # Fill the collection
    assert_nothing_raised {
      collection << Model::ScoredCollection::Entry.new(@artist_one, 100)
      collection << [@artist_two, 98]
      # The score can be ignored
      collection << @artist_three
    }
    assert_equal 3, collection.size
    assert !collection.empty?
    
    # Iterate over the collection
    n = 0
    collection.each {|entry|
      assert entry.entity.is_a?(Model::Artist), entry.entity.inspect
      assert((entry.score.is_a?(Integer) or entry.score.nil?), entry.score.inspect)
      n += 1
    }
    assert_equal collection.size, n
    
    # Iterate over the artists only, ignoring the scores
    n = 0
    collection.entities.each {|artist|
      assert artist.is_a?(Model::Artist), artist.inspect
      n += 1
    }
    assert_equal collection.size, n
    
    # Random access
    assert_equal @artist_one, collection[0].entity
    assert_equal 100, collection[0].score
    assert_equal @artist_two, collection[1].entity
    assert_equal 98, collection[1].score
    assert_equal @artist_three, collection[2].entity
    assert_equal nil, collection[2].score
    
    # Convert collection to array
    array = collection.to_a
    assert_equal @artist_one, array[0].entity
    assert_equal 100, array[0].score
    assert_equal @artist_two, array[1].entity
    assert_equal 98, array[1].score
    assert_equal @artist_three, array[2].entity
    assert_equal nil, array[2].score
    
    # Access the entities as an array
    assert_equal @artist_one, collection.entities[0]
    assert_equal @artist_two, collection.entities[1]
    assert_equal @artist_three, collection.entities[2]
  end

end