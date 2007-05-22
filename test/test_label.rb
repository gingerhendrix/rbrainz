# $Id$
# Copyright (c) 2007, Philipp Wolfer
# All rights reserved.
# See LICENSE for permissions.

require 'test_entity'

# Unit test for the Label model.
class TestLabel < Test::Unit::TestCase

  def setup
    @tested_class = Model::Label
    @invalid_entity_types = [:artist, :release, :track]
    @releases = [Model::Release.new, Model::Release.new]
  end

  def teardown
  end
  
  # Include the tests for Entity
  include TestEntity

  def test_new_label
    label = nil
    assert_nothing_raised {label = Model::Label.new}
    assert label.is_a?(Model::Entity)
  end
  
  def test_name
    label = Model::Label.new
    assert label.name.nil?
    assert_nothing_raised {label.name = 'Century Media'}
    assert_equal 'Century Media', label.name
  end
  
  def test_sort_name
    label = Model::Label.new
    assert label.sort_name.nil?
    assert_nothing_raised {label.sort_name = 'Century Media'}
    assert_equal 'Century Media', label.sort_name
  end
  
  def test_disambiguation
    label = Model::Label.new
    assert label.disambiguation.nil?
    assert_nothing_raised {label.disambiguation = 'Disambiguation comment'}
    assert_equal 'Disambiguation comment', label.disambiguation
  end
  
  def test_code
    label = Model::Label.new
    assert label.code.nil?
    assert_nothing_raised {label.code = '6975'}
    assert_equal '6975', label.code
  end
  
  def test_country
    label = Model::Label.new
    assert label.country.nil?
    assert_nothing_raised {label.country = 'DE'}
    assert_equal 'DE', label.country
  end
  
  def test_type
    label = Model::Label.new
    assert label.type.nil?
    assert_nothing_raised {label.type = Model::Label::TYPE_DISTRIBUTOR}
    assert_equal Model::Label::TYPE_DISTRIBUTOR, label.type
    assert_nothing_raised {label.type = Model::Label::TYPE_HOLDING}
    assert_equal Model::Label::TYPE_HOLDING, label.type
    assert_nothing_raised {label.type = Model::Label::TYPE_ORIGINAL_PRODUCTION}
    assert_equal Model::Label::TYPE_ORIGINAL_PRODUCTION, label.type
    assert_nothing_raised {label.type = Model::Label::TYPE_BOOTLEG_PRODUCTION}
    assert_equal Model::Label::TYPE_BOOTLEG_PRODUCTION, label.type
    assert_nothing_raised {label.type = Model::Label::TYPE_REISSUE_PRODUCTION}
    assert_equal Model::Label::TYPE_REISSUE_PRODUCTION, label.type
  end
  
  def test_founding_date
    label = Model::Label.new
    date = Model::IncompleteDate.new '1988-04-18'
    assert_nothing_raised {label.founding_date}
    assert_equal nil, label.founding_date
    assert_nothing_raised {label.founding_date = date}
    assert_equal date, label.founding_date
    
    # It should be able to supply a date as a string,
    # but Label should convert it to an IncompleteDate.
    assert_nothing_raised {label.founding_date = '1988-04-20'}
    assert_equal Model::IncompleteDate.new('1988-04-20'), label.founding_date
  end
  
  def test_dissolving_date
    label = Model::Label.new
    date = Model::IncompleteDate.new '1988-04-18'
    assert_nothing_raised {label.dissolving_date}
    assert_equal nil, label.dissolving_date
    assert_nothing_raised {label.dissolving_date = date}
    assert_equal date, label.dissolving_date
    
    # It should be able to supply a date as a string,
    # but Label should convert it to an IncompleteDate.
    assert_nothing_raised {label.dissolving_date = '1988-04-20'}
    assert_equal Model::IncompleteDate.new('1988-04-20'), label.dissolving_date
  end
  
  # Many releases can be added
  def test_add_and_remove_releases
    label = Model::Label.new
    assert_equal 0, label.releases.size
    assert_nothing_raised {label.releases << @releases[0]}
    assert_equal 1, label.releases.size
    assert_nothing_raised {label.releases << @releases[1]}
    assert_equal 2, label.releases.size
    
    assert_nothing_raised {label.releases.delete @releases[1]}
    assert_equal 1, label.releases.size
    assert_nothing_raised {label.releases.delete @releases[0]}
    assert_equal 0, label.releases.size
  end
  
  # You can pass an array of releases to add them all.
  def test_add_several_releases_at_once
    label = Model::Label.new
    assert_nothing_raised {label.releases = @releases}
    assert_equal @releases, label.releases
  end
  
end
