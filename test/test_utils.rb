# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'test/unit'
require 'rbrainz/model'
include MusicBrainz

# Unit test for the methods in the Utils module.
class TestUtils < Test::Unit::TestCase

  def setup
  end

  def teardown
  end
  
  def test_country_names
    assert_equal 'Germany', Utils.get_country_name('DE')
    assert_equal nil, Utils.get_country_name('UNKNOWN')
  end
  
  def test_language_names
    assert_equal 'English', Utils.get_language_name('ENG')
    assert_equal nil, Utils.get_language_name('UNKNOWN')
  end
  
  def test_script_names
    assert_equal 'Cyrillic', Utils.get_script_name('Cyrl')
    assert_equal nil, Utils.get_script_name('UNKNOWN')
  end
  
  def test_release_type_names
    assert_equal 'Bootleg', Utils.get_release_type_name(Model::Release::TYPE_BOOTLEG)
    assert_equal nil, Utils.get_release_type_name('UNKNOWN')
  end
  
end
