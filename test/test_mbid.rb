# $Id$
# Copyright (c) 2007, Philipp Wolfer
# All rights reserved.
# See LICENSE for permissions.

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
                      '727ad90b-7ef4-48d2-8f16-c34016544822.html']
  end

  def teardown
  end
  
  def test_private_new
    assert_raise(NoMethodError) {Model::MBID.new}
  end
  
  def test_from_uri
    @valid_entities.each{|entity|
      @valid_uuids.each{|uuid|
        assert_nothing_raised \
          {Model::MBID.from_uri 'http://musicbrainz.org/' + entity.to_s + '/' + uuid}
      }
    }
    @invalid_uris.each{|uri|
      assert_raise(Model::InvalidMBIDError) {Model::MBID.from_uri uri}
    }
  end
  
  def test_from_uuid
    @valid_entities.each{|entity|
      @valid_uuids.each{|uuid|
        assert_nothing_raised {Model::MBID.from_uuid entity, uuid}
      }
    }
    @invalid_entities.each{|entity|
      assert_raise(Model::UnknownEntityError, 'Invalid entity ' + entity.inspect + '') \
        {Model::MBID.from_uuid entity, @valid_uuids[0]}
    }
    @invalid_uuids.each{|uuid|
      assert_raise(Model::InvalidUUIDError, 'Invalid uuid ' + uuid.inspect + '') \
        {Model::MBID.from_uuid @valid_entities[0], uuid}
    }
  end
  
  def test_to_s
    @valid_entities.each{|entity|
      @valid_uuids.each{|uuid|
        uri = 'http://musicbrainz.org/' + entity.to_s + '/' + uuid
        mbid = Model::MBID.from_uuid entity, uuid
        assert_equal uri, mbid.to_s
        mbid = Model::MBID.from_uri uri
        assert_equal uri, mbid.to_s
      }
    }
  end
  
  def test_read_attributes
    @valid_entities.each{|entity|
      @valid_uuids.each{|uuid|
        mbid = Model::MBID.from_uuid entity, uuid
        assert_equal entity.to_sym, mbid.entity
        assert_equal uuid, mbid.uuid
        mbid = Model::MBID.from_uri 'http://musicbrainz.org/' + entity.to_s + '/' + uuid
        assert_equal entity.to_sym, mbid.entity
        assert_equal uuid, mbid.uuid
      }
    }
  end
  
  # Test if the attributes are read only.
  def test_write_attributes
    mbid = Model::MBID.from_uuid @valid_entities[0], @valid_uuids[0]
    assert_raise(NoMethodError) {mbid.entity = :release}
    assert_raise(NoMethodError) {mbid.uuid = @valid_uuids[0]}
  end
  
  def test_equality
    mbid1 = Model::MBID.from_uuid @valid_entities[0], @valid_uuids[0]
    mbid2 = Model::MBID.from_uuid @valid_entities[0], @valid_uuids[0]
    assert_equal mbid1, mbid1
    assert_equal mbid1, mbid2
  end
  
end
