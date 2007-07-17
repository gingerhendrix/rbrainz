# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'test_entity'

# Unit test for the Label model.
class TestLabel < Test::Unit::TestCase

  def setup
    @tested_class = Model::Label
    @invalid_entity_types = [:artist, :release, :track]
    @releases = [Model::Release.new, Model::Release.new]
    @aliases = [Model::Alias.new, Model::Alias.new]
  end

  def teardown
  end
  
  # Include the tests for Entity
  include TestEntity

  def test_new_label
    label = nil
    assert_nothing_raised {label = Model::Label.new}
    assert label.is_a?(Model::Entity)
    
    mbid = Model::MBID.new('9d30e408-1559-448b-b491-2f8de1583ccf', label.entity_type)
    assert_nothing_raised {label = Model::Label.new(
      mbid,
      Model::Label::TYPE_ORIGINAL_PRODUCTION,
      'Century Media',
      'Century Media'
      )}
    assert_equal mbid, label.id
    assert_equal Model::Label::TYPE_ORIGINAL_PRODUCTION, label.type
    assert_equal 'Century Media', label.name
    assert_equal 'Century Media', label.sort_name
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
  
  def test_unique_name
    label = Model::Label.new
    label.name = 'EMI'
    label.disambiguation = 'Taiwan'
    assert_equal 'EMI (Taiwan)', label.unique_name
    assert_equal 'EMI (Taiwan)', label.to_s
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
  
  def test_begin_date
    label = Model::Label.new
    date = Model::IncompleteDate.new '1988-04-18'
    assert_nothing_raised {label.begin_date}
    assert_equal nil, label.begin_date
    assert_nothing_raised {label.begin_date = date}
    assert_equal date, label.begin_date
    
    # It should be able to supply a date as a string,
    # but Label should convert it to an IncompleteDate.
    assert_nothing_raised {label.begin_date = '1988-04-20'}
    assert_equal Model::IncompleteDate.new('1988-04-20'), label.begin_date
  end
  
  def test_end_date
    label = Model::Label.new
    date = Model::IncompleteDate.new '1988-04-18'
    assert_nothing_raised {label.end_date}
    assert_equal nil, label.end_date
    assert_nothing_raised {label.end_date = date}
    assert_equal date, label.end_date
    
    # It should be able to supply a date as a string,
    # but Label should convert it to an IncompleteDate.
    assert_nothing_raised {label.end_date = '1988-04-20'}
    assert_equal Model::IncompleteDate.new('1988-04-20'), label.end_date
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
  
  # Many aliases can be added
  def test_add_and_remove_aliases
    label = Model::Label.new
    assert_equal 0, label.aliases.size
    assert_nothing_raised {label.aliases << @aliases[0]}
    assert_equal 1, label.aliases.size
    assert_nothing_raised {label.aliases << @aliases[1]}
    assert_equal 2, label.aliases.size
    
    assert_nothing_raised {label.aliases.delete @aliases[1]}
    assert_equal 1, label.aliases.size
    assert_nothing_raised {label.aliases.delete @aliases[0]}
    assert_equal 0, label.aliases.size
  end
  
end
