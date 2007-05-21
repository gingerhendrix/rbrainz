# $Id$
# Copyright (c) 2007, Philipp Wolfer
# All rights reserved.
# See LICENSE for permissions.

require 'test_entity'

# Unit test for the Release model.
class TestRelease < Test::Unit::TestCase

  def setup
    @tested_class = Model::Release
    @invalid_entity_types = [:artist, :track, :label]
  end

  def teardown
  end
  
  # Include the tests for Entity
  include TestEntity

  def test_not_implemented
    assert false, 'Unit test for ' + self.class.name + ' not implemented!'
  end
  
end
