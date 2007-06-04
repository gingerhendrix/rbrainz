# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'test/unit'
require 'rbrainz/model'
include MusicBrainz

# Unit test for the Alias model.
class TestAlias < Test::Unit::TestCase

  def setup
  end

  def teardown
  end
  
  def test_new_alias
    assert_nothing_raised {Model::Alias.new}
  end
  
  def test_name
    alias_ = Model::Alias.new
    alias_.name = 'Dark Tranquility'
    assert_equal 'Dark Tranquility', alias_.name
  end
  
  def test_type
    alias_ = Model::Alias.new
    alias_.type = 'Misspelling'
    assert_equal 'Misspelling', alias_.type
  end
  
  def test_script
    alias_ = Model::Alias.new
    alias_.script = 'Latn'
    assert_equal 'Latn', alias_.script
  end
  
  def test_to_string
    alias_ = Model::Alias.new
    assert_equal '', alias_.to_s
    alias_.name = 'Dark Tranquility'
    alias_.type = 'Misspelling'
    alias_.script = 'Latn'
    assert_equal 'Dark Tranquility', alias_.to_s
  end
  
end
