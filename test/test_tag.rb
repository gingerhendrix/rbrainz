# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'test/unit'
require 'rbrainz/model'
include MusicBrainz

# Unit test for the Tag model.
class TestTag < Test::Unit::TestCase

  def setup
  end

  def teardown
  end
  
  def test_tag
    tag = nil
    assert_nothing_raised {tag = Model::Tag.new}
    tag.text = 'british'
    tag.count = 11
    assert_equal 'british', tag.text
    assert_equal 'british', tag.to_s
    assert_equal 11, tag.count
    
    assert_nothing_raised {tag = Model::Tag.new('british')}
    assert_equal 'british', tag.text
    assert_equal nil, tag.count
  
    assert_nothing_raised {tag = Model::Tag.new('british', 10)}
    assert_equal 'british', tag.text
    assert_equal 10, tag.count
  end
  
end
