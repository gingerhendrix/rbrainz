# $Id$
# Copyright (c) 2007, Philipp Wolfer
# All rights reserved.
# See LICENSE for permissions.

require 'test/unit'
require 'rbrainz/model'
include MusicBrainz

# Unit test for the IncompleteDate model.
class TestIncompleteDate < Test::Unit::TestCase

  def setup
    @date_year_month_day = Model::IncompleteDate.new '1980-08-22'
    @date_year_month     = Model::IncompleteDate.new '1980-08'
    @date_year           = Model::IncompleteDate.new '1980'
  end

  def teardown
  end
  
  # Invalid dates shouldn't be accepted.
  def test_date_validation
    assert false
  end
  
  def test_to_string
    assert_equal '1980-08-22', @date_year_month_day.to_s
    assert_equal '1980-08',    @date_year_month.to_s
    assert_equal '1980',       @date_year.to_s
  end
  
  def test_equality
    assert_equal(@date_year_month_day, @date_year_month,
                 "#{@date_year_month_day.to_s} <=> #{@date_year_month.to_s}")
    assert_equal(@date_year_month, @date_year,
                 "#{@date_year_month.to_s} <=> #{@date_year.to_s}")
    assert_equal(@date_year, @date_year_month_day,
                 "#{@date_year.to_s} <=> #{@date_year_month_day.to_s}")
  end
  
end
