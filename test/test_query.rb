# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'test/unit'
require 'rbrainz'
require 'mock_webservice'
require 'test_factory'
include MusicBrainz

# Unit test for the Query class.
class TestQuery < Test::Unit::TestCase

  def setup
    @webservice = MockWebservice.new
    @query = Webservice::Query.new(@webservice)
  end

  def teardown
  end
  
  def test_get_artist
    id = 'c0b2500e-0cef-4130-869d-732b23ed9df5'
    entity = @query.get_artist_by_id(id)
    assert entity.is_a?(Model::Artist)
    assert_equal id, entity.id.uuid
    assert_equal 'Tori Amos', entity.name
  end
  
  def test_get_artists
    filter = Webservice::ArtistFilter.new(:name=>'Tori Amos')
    collection = @query.get_artists(filter)
    assert collection.is_a?(Model::Collection)
    assert_equal 3, collection.size
    collection.entities.each {|e| assert e.is_a?(Model::Artist) }
  end
  
  def test_get_release
    id = '290e10c5-7efc-4f60-ba2c-0dfc0208fbf5'
    entity = @query.get_release_by_id(id)
    assert entity.is_a?(Model::Release)
    assert_equal id, entity.id.uuid
    assert_equal 'Under the Pink', entity.title
  end
  
  def test_get_releases
    filter = Webservice::ReleaseFilter.new(:title=>'Under the Pink')
    collection = @query.get_releases(filter)
    assert collection.is_a?(Model::Collection)
    assert_equal 2, collection.size
    collection.entities.each {|e| assert e.is_a?(Model::Release) }
  end
  
  def test_get_track
    id = 'd6118046-407d-4e06-a1ba-49c399a4c42f'
    entity = @query.get_track_by_id(id)
    assert entity.is_a?(Model::Track)
    assert_equal id, entity.id.uuid
    assert_equal 'Silent All These Years', entity.title
  end
  
  def test_get_tracks
    filter = Webservice::TrackFilter.new(:title=>'Little Earthquakes')
    collection = @query.get_tracks(filter)
    assert collection.is_a?(Model::Collection)
    assert_equal 3, collection.size
    collection.entities.each {|e| assert e.is_a?(Model::Track) }
  end
  
  def test_get_label
    id = '50c384a2-0b44-401b-b893-8181173339c7'
    entity = @query.get_label_by_id(id)
    assert entity.is_a?(Model::Label)
    assert_equal id, entity.id.uuid
    assert_equal 'Atlantic Records', entity.name
  end
  
  def test_get_labels
    filter = Webservice::LabelFilter.new(:name=>'Atlantic Records')
    collection = @query.get_labels(filter)
    assert collection.is_a?(Model::Collection)
    assert_equal 2, collection.size
    collection.entities.each {|e| assert e.is_a?(Model::Label) }
  end
  
  def test_get_user_by_name
    user = @query.get_user_by_name('matt')
    assert user.is_a?(Model::User)
    assert_equal false, user.show_nag?
  end
  
  def test_factory
    factory = MyFactory.new
    query = Webservice::Query.new(@webservice, :factory=>factory)
    
    id = '290e10c5-7efc-4f60-ba2c-0dfc0208fbf5'
    entity = query.get_release_by_id(id)
    assert entity.is_a?(MyRelease)
  end
  
end
