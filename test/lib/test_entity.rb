# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'test/unit'
require 'rbrainz/model'
include MusicBrainz

# Unit test for the entity model.
# This is only a test module which defines general
# tests on Entity. The tests should be executed by
# all subclass tests.
module TestEntity

  def test_valid_mbid
    entity = @tested_class.new
    valid_mbid = Model::MBID.parse('9d30e408-1559-448b-b491-2f8de1583ccf', @tested_class.entity_type )
    
    assert_equal nil, entity.id
    assert_nothing_raised {entity.id = valid_mbid}
    assert_equal valid_mbid, entity.id
  end
  
  def test_valid_mbid_from_uuid
    entity = @tested_class.new
    valid_mbid = Model::MBID.parse('9d30e408-1559-448b-b491-2f8de1583ccf', @tested_class.entity_type )
    
    assert_equal nil, entity.id
    assert_nothing_raised {entity.id = valid_mbid.uuid}
    assert_equal valid_mbid, entity.id
  end
  
  def test_valid_mbid_from_uri
    entity = @tested_class.new
    valid_mbid = Model::MBID.parse( '9d30e408-1559-448b-b491-2f8de1583ccf', @tested_class.entity_type )
    
    assert_equal nil, entity.id
    assert_nothing_raised {entity.id = valid_mbid.to_s}
    assert_equal valid_mbid, entity.id
  end
  
  def test_invalid_mbid_entity_type_not_matching
    entity = @tested_class.new
    @invalid_entity_types.each {|type|
      invalid_mbid = Model::MBID.parse( '9d30e408-1559-448b-b491-2f8de1583ccf', type )
      assert_raise(Model::EntityTypeNotMatchingError) {entity.id = invalid_mbid}
      assert_raise(Model::EntityTypeNotMatchingError) {entity.id = invalid_mbid.to_s}
    }
    assert_equal nil, entity.id
  end

  def test_relations
    entity = @tested_class.new
    
    # Create some test relations
    artist_rel = Model::Relation.new
    artist_rel.target = Model::Artist.new
    artist_rel.type = Model::NS_REL_1 + 'Vocal'
    artist_rel.direction = Model::Relation::DIR_BACKWARD
    artist_rel.attributes << 'Guest'
    artist_rel.attributes << 'Lead'
    assert_nothing_raised {entity.add_relation artist_rel}
    
    track_rel = Model::Relation.new
    track_rel.target = Model::Track.new
    track_rel.type = Model::NS_REL_1 + 'Vocal'
    track_rel.direction = Model::Relation::DIR_FORWARD
    track_rel.attributes << 'Lead'
    track_rel.attributes << 'Guest'
    assert_nothing_raised {entity.add_relation track_rel}
    
    url_rel = Model::Relation.new
    url_rel.target = 'http://www.example.com'
    url_rel.type = Model::NS_REL_1 + 'OfficialHomepage'
    assert_nothing_raised {entity.add_relation url_rel}
    
    # Get all relations
    rel_list = []
    assert_nothing_raised {rel_list = entity.get_relations()}
    assert_equal 3, rel_list.size
    assert rel_list.include?(artist_rel)
    assert rel_list.include?(track_rel)
    assert rel_list.include?(url_rel)
  
    # Get only artist relation by target type
    assert_nothing_raised {rel_list = entity.get_relations(
                             :target_type => Model::Relation::TO_ARTIST)}
    assert_equal 1, rel_list.size
    assert rel_list.include?(artist_rel)
    
    # Get only url relation type
    assert_nothing_raised {rel_list = entity.get_relations(
                             :relation_type => Model::NS_REL_1 + 'OfficialHomepage')}
    assert_equal 1, rel_list.size
    assert rel_list.include?(url_rel)
    
    # Get only artist and track relation by attribute
    assert_nothing_raised {rel_list = entity.get_relations(
                             :required_attributes => ['Guest', 'Lead'])}
    assert_equal 2, rel_list.size
    assert rel_list.include?(artist_rel)
    assert rel_list.include?(track_rel)
    
    # Get only artist relation by target type
    assert_nothing_raised {rel_list = entity.get_relations(
                             :direction => Model::Relation::DIR_BACKWARD)}
    assert_equal 1, rel_list.size
    assert rel_list.include?(artist_rel)
    
    # Test the target types
    target_types = entity.relation_target_types
    assert_equal 3, target_types.size, target_types.inspect
    [Model::Relation::TO_ARTIST, Model::Relation::TO_TRACK,
     Model::Relation::TO_URL].each {|type|
      assert target_types.include?(type), target_types.inspect
    }
  end
  
end
