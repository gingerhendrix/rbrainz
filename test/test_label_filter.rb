# $Id$
# Copyright (c) 2007, Philipp Wolfer
# All rights reserved.
# See LICENSE for permissions.

require 'test/unit'
require 'testing_helper'
require 'rbrainz'
include MusicBrainz

# Unit test for the LabelFilter class.
class TestLabelFilter < Test::Unit::TestCase

  def setup
    @filter_hash = {:name => 'Century Media', :limit => 10, :offset => 20}
  end

  def teardown
  end
  
  def test_filter
    filter = Webservice::LabelFilter.new(@filter_hash)
    filter_string = filter.to_s
    assert_not_equal '&', filter_string[0]
    
    result_hash = query_string_to_hash filter_string
    assert_equal @filter_hash[:name], result_hash['name'], filter_string
    assert_equal @filter_hash[:limit].to_s, result_hash['limit'], filter_string
    assert_equal @filter_hash[:offset].to_s, result_hash['offset'], filter_string
  end
  
  def test_empty_filter
    filter = Webservice::LabelFilter.new({})
    assert_equal '', filter.to_s
  end
  
end
