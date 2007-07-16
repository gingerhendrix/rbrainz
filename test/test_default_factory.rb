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
class TestDefaultFactory < Test::Unit::TestCase

  def setup
  end

  def teardown
  end
  
  def test_new_artist
    factory = Model::DefaultFactory.new
    assert factory.new_artist.is_a?(Model::Artist)
    assert factory.new_entity(:artist).is_a?(Model::Artist)
  end

  def test_new_label
    factory = Model::DefaultFactory.new
    assert factory.new_label.is_a?(Model::Label)
    assert factory.new_entity(:label).is_a?(Model::Label)
  end

  def test_new_release
    factory = Model::DefaultFactory.new
    assert factory.new_release.is_a?(Model::Release)
    assert factory.new_entity(:release).is_a?(Model::Release)
  end

  def test_new_track
    factory = Model::DefaultFactory.new
    assert factory.new_track.is_a?(Model::Track)
    assert factory.new_entity(:track).is_a?(Model::Track)
  end
  
  def test_new_alias
    factory = Model::DefaultFactory.new
    assert factory.new_alias.is_a?(Model::Alias)
  end

  def test_new_disc
    factory = Model::DefaultFactory.new
    assert factory.new_disc.is_a?(Model::Disc)
  end

  def test_new_relation
    factory = Model::DefaultFactory.new
    assert factory.new_relation.is_a?(Model::Relation)
  end

  def test_new_release_event
    factory = Model::DefaultFactory.new
    assert factory.new_release_event.is_a?(Model::ReleaseEvent)
  end

  def test_new_tag
    factory = Model::DefaultFactory.new
    assert factory.new_tag.is_a?(Model::Tag)
  end

  def test_new_user
    factory = Model::DefaultFactory.new
    assert factory.new_user.is_a?(Model::User)
  end

end
