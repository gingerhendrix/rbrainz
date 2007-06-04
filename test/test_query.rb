# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'test/unit'
require 'rbrainz'
include MusicBrainz

# Unit test for the Query class.
class TestQuery < Test::Unit::TestCase

  def setup
  end

  def teardown
  end
  
  # TODO: Implement a mock webservice for testing
  def test_not_implemented
    assert false, 'Unit test for ' + self.class.name + ' not implemented!'
  end
  
end
