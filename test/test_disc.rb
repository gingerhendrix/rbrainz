# $Id$
# Copyright (c) 2007, Philipp Wolfer
# All rights reserved.
# See LICENSE for permissions.

require 'test/unit'
require 'rbrainz/model'
include MusicBrainz

# Unit test for the Disc model.
class TestDisc < Test::Unit::TestCase

  def setup
  end

  def teardown
  end
  
  def test_new_disc
    disc = nil
    assert_nothing_raised {disc = Model::Disc.new}
  end
  
  def test_id
    disc = Model::Disc.new
    assert disc.id.nil?
    assert_nothing_raised {disc.id = 'Tit3F0Do_sZ_7NbfM_1vlEbF0wo-'}
    assert_equal 'Tit3F0Do_sZ_7NbfM_1vlEbF0wo-', disc.id
  end

  def test_sectors
    disc = Model::Disc.new
    assert disc.sectors.nil?
    assert_nothing_raised {disc.sectors = 264432}
    assert_equal 264432, disc.sectors
  end
  
end
