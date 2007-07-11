# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'test/unit'
require 'rbrainz'
include MusicBrainz

# Unit test for the TrackIncludes class.
class TestTrackIncludes < Test::Unit::TestCase

  def setup
  end

  def teardown
  end
  
  def test_includes
    includes = Webservice::TrackIncludes.new(
      :artist => true,
      :releases => true,
      :puids => true,
      :artist_rels => true,
      :release_rels => true,
      :track_rels => true,
      :label_rels => true,
      :url_rels => true,
      :tags => true
      )
    result_string = includes.to_s
    assert_equal 'inc=', result_string[0..3]
    
    result_array = result_string[4..-1].split('%20')
    assert result_array.include?('artist')
    assert result_array.include?('releases')
    assert result_array.include?('puids')
    assert result_array.include?('artist-rels')
    assert result_array.include?('release-rels')
    assert result_array.include?('track-rels')
    assert result_array.include?('label-rels')
    assert result_array.include?('url-rels')
    assert result_array.include?('tags')
  end
  
  def test_empty_includes
    includes = Webservice::TrackIncludes.new(
      :artist => false,
      :releases => false,
      :puids => false,
      :artist_rels => false,
      :release_rels => false,
      :track_rels => false,
      :label_rels => false,
      :url_rels => false,
      :tags => false
      )
    assert_equal '', includes.to_s
  
    includes = Webservice::TrackIncludes.new({})
    assert_equal '', includes.to_s
  end
  
end
