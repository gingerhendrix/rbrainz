# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

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
  
  def test_new
    date = nil
    assert_nothing_raised {date = Model::IncompleteDate.new('1969-01-05')}
    assert_equal 1969, date.year
    assert_equal 1, date.month
    assert_equal 5, date.day
    assert_nothing_raised {date = Model::IncompleteDate.new(1980)}
    assert_equal 1980, date.year
    assert_nothing_raised {date = Model::IncompleteDate.new(Date.parse('1969-01-05'))}
    assert_equal 1969, date.year
    assert_equal 1, date.month
    assert_equal 5, date.day
#    assert_nothing_raised {date = Model::IncompleteDate.new(nil)}
#    assert_equal nil, date.year
  end
  
  def test_invalid_format
    assert_raise(ArgumentError) {date = Model::IncompleteDate.new(nil)}
    assert_raise(ArgumentError) {date = Model::IncompleteDate.new('69-01-05')}
    assert_raise(ArgumentError) {date = Model::IncompleteDate.new(69)}
    assert_raise(ArgumentError) {date = Model::IncompleteDate.new('1969/01/05')}
    assert_raise(ArgumentError) {date = Model::IncompleteDate.new('01-05-1969')}
  end
  
  def test_to_string
    assert_equal '1980-08-22', @date_year_month_day.to_s
    assert_equal '1980-08',    @date_year_month.to_s
    assert_equal '1980',       @date_year.to_s
  end
  
  def test_range
    assert_equal Date.civil(1980,8,22), @date_year_month_day.begin
    assert_equal Date.civil(1980,8,22), @date_year_month_day.end
    assert !@date_year_month_day.exclude_end?
    
    assert_equal Date.civil(1980, 8, 1), @date_year_month.begin
    assert_equal Date.civil(1980, 8, 31), @date_year_month.end
    assert !@date_year_month.exclude_end?

    assert_equal Date.civil(1980, 1, 1), @date_year.begin
    assert_equal Date.civil(1980, 12, 31), @date_year.end, @date_year.end.to_s
    assert !@date_year.exclude_end?
  end
  
  def test_eql
    assert @date_year.eql?(@date_year)
    assert @date_year_month.eql?(Date.civil(1980, 8, 1)..Date.civil(1980, 8, 31))
    assert @date_year_month_day.eql?(Date.civil(1980, 8, 22))
    assert !@date_year.eql?(@date_year_month_day)
  end

  def test_include
    assert @date_year.include?(@date_year)
    assert @date_year.include?(@date_year_month)
    assert @date_year.include?(@date_year_month_day)
    assert @date_year_month.include?(Date.civil(1980, 8, 1))
    assert @date_year_month.include?(Date.civil(1980, 8, 22))
    assert @date_year_month.include?(Date.civil(1980, 8, 31))
    assert @date_year_month.include?(Date.civil(1980, 8, 1)..Date.civil(1980, 8, 31))
    assert !@date_year_month.include?(Date.civil(1980, 8, 1)..Date.civil(1980, 9, 1))
    assert !@date_year_month.include?(Date.civil(1980, 7, 30))
    assert !@date_year_month.include?(Date.civil(1980, 9, 1))
  end
  
end
