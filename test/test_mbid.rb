# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'test/unit'
require 'rbrainz/model'
include MusicBrainz

# Unit test for the MBID model.
class TestMBID < Test::Unit::TestCase

  def setup
    @valid_entities = [:artist, :release, :track, :label,
                       'artist', 'release', 'track', 'label']
    @valid_uuids = ['9d30e408-1559-448b-b491-2f8de1583ccf']
    @invalid_uris = [nil, '', 'http://musicbrainz.org/labels/727ad90b-7ef4-48d2-8f16-c34016544822',
                     'http://musicbrainz.org/label/727ad90b-7ef4-48d2-8f16-c34016544822?']
    @invalid_entities = [nil, '', 'entity', :entity, 1]
    @invalid_uuids = [nil, '', 1, '727ad90b7ef448d28f16c34016544822',
                      '727ad90b-7ef4-48d2-8f16-c34016544822.html',
                      '9g30e408-1559-448b-b491-2f8de1583ccf']
  end

  def teardown
  end
  
  def test_parse
    assert_equal 'http://musicbrainz.org/artist/9d30e408-1559-448b-b491-2f8de1583ccf',
      Model::MBID.parse( 
        'http://musicbrainz.org/artist/9d30e408-1559-448b-b491-2f8de1583ccf', 
        :artist).to_s
    assert_equal 'http://musicbrainz.org/artist/9d30e408-1559-448b-b491-2f8de1583ccf',
      Model::MBID.parse(
      '9d30e408-1559-448b-b491-2f8de1583ccf',
      :artist ).to_s
    assert_raise(Model::EntityTypeNotMatchingError) {
      Model::MBID.parse(
      'http://musicbrainz.org/artist/9d30e408-1559-448b-b491-2f8de1583ccf',
      :label )
    }
    assert_equal Model::VARIOUS_ARTISTS_ID, Model::MBID.parse('http://musicbrainz.org/artist/89ad4ac3-39f7-470e-963a-56509c546377')
  end
  
  def test_from_uri
    @valid_entities.each{|entity|
      @valid_uuids.each{|uuid|
        assert_nothing_raised \
          {Model::MBID.parse 'http://musicbrainz.org/' + entity.to_s + '/' + uuid }
      }
    }
    @invalid_uris.each{|uri|
      assert_raise(Model::InvalidMBIDError, uri) {Model::MBID.parse uri}
    }
  end
  
  def test_from_uuid
    @valid_entities.each{|entity|
      @valid_uuids.each{|uuid|
        assert_nothing_raised {Model::MBID.parse uuid, entity}
      }
    }
    @invalid_entities.each{|entity|
      assert_raise(Model::UnknownEntityError, 'Invalid entity ' + entity.inspect + '') \
        {Model::MBID.parse @valid_uuids[0], entity}
    }
    @invalid_uuids.each{|uuid|
      assert_raise(Model::InvalidMBIDError, uuid.inspect) \
        {Model::MBID.parse uuid, @valid_entities[0]}
    }
  end
  
  def test_to_s
    @valid_entities.each{|entity|
      @valid_uuids.each{|uuid|
        uri = 'http://musicbrainz.org/' + entity.to_s + '/' + uuid
        mbid = Model::MBID.parse uuid, entity
        assert_equal uri, mbid.to_s
        mbid = Model::MBID.parse uri
        assert_equal uri, mbid.to_s
      }
    }
  end
  
  def test_read_attributes
    @valid_entities.each{|entity|
      @valid_uuids.each{|uuid|
        mbid = Model::MBID.parse uuid, entity
        assert_equal entity.to_sym, mbid.entity
        assert_equal uuid, mbid.uuid
        mbid = Model::MBID.parse 'http://musicbrainz.org/' + entity.to_s + '/' + uuid
        assert_equal entity.to_sym, mbid.entity
        assert_equal uuid, mbid.uuid
      }
    }
  end
  
  # Test if the attributes are read only.
  def test_write_attributes
    mbid = Model::MBID.parse @valid_uuids[0], @valid_entities[0]
    assert_raise(NoMethodError) {mbid.entity = :release}
    assert_raise(NoMethodError) {mbid.uuid = @valid_uuids[0]}
  end
  
  def test_equality
    mbid1 = Model::MBID.parse @valid_uuids[0], @valid_entities[0]
    mbid2 = Model::MBID.parse @valid_uuids[0], @valid_entities[0]
    assert_equal mbid1, mbid1
    assert_equal mbid1, mbid2
  end
  
end
