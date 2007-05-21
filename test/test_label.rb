# $Id$
# Copyright (c) 2007, Philipp Wolfer
# All rights reserved.
# See LICENSE for permissions.

require 'test_entity'

# Unit test for the Label model.
class TestLabel < Test::Unit::TestCase

  def setup
    @tested_class = Model::Label
    @invalid_entity_types = [:artist, :release, :track]
  end

  def teardown
  end
  
  # Include the tests for Entity
  include TestEntity

  def test_not_implemented
    assert false, 'Unit test for ' + self.class.name + ' not implemented!'
  end
  
end
