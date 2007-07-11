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
    collection = Model::Collection.new(102, 8)
    assert_equal 102, collection.count
    assert_equal 8, collection.offset
    
    collection.count = 99
    collection.offset=15
    assert_equal 99, collection.count
    assert_equal 15, collection.offset
    
    assert collection.empty?
    
    # Fill the collection
    assert_nothing_raised {
      collection << @artist_one
      collection << @artist_two
      collection << @artist_three
    }
    assert_equal 3, collection.size
    assert !collection.empty?
    
    # Iterate over the collection
    n = 0
    collection.each {|artist|
      assert artist.is_a?(Model::Artist), artist.inspect
      n += 1
    }
    assert_equal collection.size, n
    
    # Random access
    assert_equal @artist_one, collection[0]
    assert_equal @artist_two, collection[1]
    assert_equal @artist_three, collection[2]
    
    # Convert collection to array
    array = collection.to_a
    assert_equal Array, array.class
    assert_equal @artist_one, array[0]
    assert_equal @artist_two, array[1]
    assert_equal @artist_three, array[2]
  end

end