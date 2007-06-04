# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'test/unit'
require 'rbrainz/model'
include MusicBrainz

# Unit test for the Relation model.
class TestRelation < Test::Unit::TestCase

  def setup
    @target_entity = Model::Artist.new
    @target_entity.id = Model::MBID.from_uuid :artist, '727ad90b-7ef4-48d2-8f16-c34016544822'
  end

  def teardown
  end
  
  def test_new_relation
    disc = nil
    assert_nothing_raised {disc = Model::Relation.new}
  end
  
  def test_type
    relation = Model::Relation.new
    assert relation.type.nil?
    assert_nothing_raised {relation.type = Model::NS_REL_1 + 'Performer'}
    assert_equal Model::NS_REL_1 + 'Performer', relation.type
  end

  def test_direction
    relation = Model::Relation.new
    assert relation.direction.nil?
    [Model::Relation::DIR_BACKWARD, Model::Relation::DIR_FORWARD,
     Model::Relation::DIR_BOTH].each {|dir|
      assert_nothing_raised {relation.direction = dir}
      assert_equal dir, relation.direction
    }
  end

  def test_begin_date
    relation = Model::Relation.new
    date = Model::IncompleteDate.new '1988-04-18'
    assert_nothing_raised {relation.begin_date}
    assert_equal nil, relation.begin_date
    assert_nothing_raised {relation.begin_date = date}
    assert_equal date, relation.begin_date
    
    # It should be able to supply a date as a string,
    # but Relation should convert it to an IncompleteDate.
    assert_nothing_raised {relation.begin_date = '1988-04-20'}
    assert_equal Model::IncompleteDate.new('1988-04-20'), relation.begin_date
  end

  def test_end_date
    relation = Model::Relation.new
    date = Model::IncompleteDate.new '1988-04-18'
    assert_nothing_raised {relation.end_date}
    assert_equal nil, relation.end_date
    assert_nothing_raised {relation.end_date = date}
    assert_equal date, relation.end_date
    
    # It should be able to supply a date as a string,
    # but Relation should convert it to an IncompleteDate.
    assert_nothing_raised {relation.end_date = '1988-04-20'}
    assert_equal Model::IncompleteDate.new('1988-04-20'), relation.end_date
  end
  
  def test_target
    relation = Model::Relation.new
    assert relation.target.nil?
    assert_nothing_raised {relation.target = @target_entity}
    assert_equal @target_entity, relation.target
    assert_nothing_raised {relation.target = 'http://www.example.com'}
    assert_equal 'http://www.example.com', relation.target
  end
  
  # Target type is read-only and is automatically set
  # when the target is set.
  def test_target_type
    relation = Model::Relation.new
    assert relation.target_type.nil?
    assert_raise(NoMethodError) {relation.target_type = Model::Relation::TO_RELEASE}
    
    relation.target = Model::Artist.new
    assert_equal Model::Relation::TO_ARTIST, relation.target_type
    
    relation.target = Model::Release.new
    assert_equal Model::Relation::TO_RELEASE, relation.target_type
    
    relation.target = Model::Track.new
    assert_equal Model::Relation::TO_TRACK, relation.target_type
    
    relation.target = Model::Label.new
    assert_equal Model::Relation::TO_LABEL, relation.target_type
    
    relation.target = 'http://www.example.com'
    assert_equal Model::Relation::TO_URL, relation.target_type
  end

  def test_attributes
    relation = Model::Relation.new
    assert_equal 0, relation.attributes.size
    assert_nothing_raised {relation.attributes << Model::NS_REL_1 + 'Lead'}
    assert_equal 1, relation.attributes.size
    assert_nothing_raised {relation.attributes.delete(Model::NS_REL_1 + 'Lead')}
    assert_equal 0, relation.attributes.size
  end
  
  # The to_s method could return a readable representation of the relation.
  #def test_to_string
  #end
   
end
