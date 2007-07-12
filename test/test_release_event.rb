# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'test/unit'
require 'rbrainz/model'
include MusicBrainz

# Unit test for the ReleaseEvent model.
class TestReleaseEvent < Test::Unit::TestCase

  def setup
  end

  def teardown
  end
  
  def test_new
    event = nil
    assert_nothing_raised {event = Model::ReleaseEvent.new(
      'SE',
      '2007-04-18'
      )}
    assert_equal 'SE', event.country
    assert_equal Model::IncompleteDate.new('2007-04-18'), event.date
  end
  
  def test_date
    event = Model::ReleaseEvent.new
    date = Model::IncompleteDate.new '2007-04-18'
    assert_nothing_raised {event.date}
    assert_equal nil, event.date
    assert_nothing_raised {event.date = date}
    assert_equal date, event.date
    
    # It should be able to supply a date as a string,
    # but EventRelease should convert it to an IncompleteDate.
    assert_nothing_raised {event.date = '2007-04-20'}
    assert_equal Model::IncompleteDate.new('2007-04-20'), event.date
  end
  
  def test_country
    event = Model::ReleaseEvent.new
    assert_nothing_raised {event.country}
    assert_equal nil, event.country
    assert_nothing_raised {event.country = 'SE'}
    assert_equal 'SE', event.country
  end

  def test_catalog_number
    event = Model::ReleaseEvent.new
    assert_nothing_raised {event.catalog_number}
    assert_equal nil, event.catalog_number
    assert_nothing_raised {event.catalog_number = 'CM 77615-0'}
    assert_equal 'CM 77615-0', event.catalog_number
  end
  
  def test_barcode
    event = Model::ReleaseEvent.new
    assert_nothing_raised {event.barcode}
    assert_equal nil, event.barcode
    assert_nothing_raised {event.barcode = '5051099761506'}
    assert_equal '5051099761506', event.barcode
  end

  def test_label
    event = Model::ReleaseEvent.new
    label = Model::Label.new
    label.name = 'Century Media'
    assert_nothing_raised {event.label}
    assert_equal nil, event.label
    assert_nothing_raised {event.label = label}
    assert_equal label, event.label
  end

end
