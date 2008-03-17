# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'test/unit'
require 'rbrainz'
include MusicBrainz

# Unit test for the ReleaseIncludes class.
class TestReleaseIncludes < Test::Unit::TestCase

  def setup
  end

  def teardown
  end
  
  def test_includes
    includes = Webservice::ReleaseIncludes.new(
      :artist => true,
      :counts => true,
      :release_events => true,
      :discs => true,
      :tracks => true,
      :labels => true,
      :artist_rels => true,
      :release_rels => true,
      :track_rels => true,
      :label_rels => true,
      :url_rels => true,
      :track_level_rels => true,
      :tags => true
      )
    result_string = includes.to_s
    assert_equal 'inc=', result_string[0..3]
    
    result_array = result_string[4..-1].split(/%20|\+/)
    assert result_array.include?('artist')
    assert result_array.include?('counts')
    assert result_array.include?('release-events')
    assert result_array.include?('discs')
    assert result_array.include?('tracks')
    assert result_array.include?('labels')
    assert result_array.include?('artist-rels')
    assert result_array.include?('release-rels')
    assert result_array.include?('track-rels')
    assert result_array.include?('label-rels')
    assert result_array.include?('url-rels')
    assert result_array.include?('track-level-rels')
    assert result_array.include?('tags')
  end
  
  def test_empty_includes
    includes = Webservice::ReleaseIncludes.new(
      :artist => false,
      :counts => false,
      :release_events => false,
      :discs => false,
      :tracks => false,
      :labels => false,
      :artist_rels => false,
      :release_rels => false,
      :track_rels => false,
      :label_rels => false,
      :url_rels => false,
      :track_level_rels => false,
      :tags => false
      )
    assert_equal '', includes.to_s
  
    includes = Webservice::ReleaseIncludes.new({})
    assert_equal '', includes.to_s
  end
  
end
