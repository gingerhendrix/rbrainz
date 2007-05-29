# $Id$
# Copyright (c) 2007, Philipp Wolfer
# All rights reserved.
# See LICENSE for permissions.

require 'test/unit'
require 'rbrainz'
include MusicBrainz

# Unit test for the Webservice class.
class TestWebservice < Test::Unit::TestCase

  def setup
    # See http://wiki.musicbrainz.org/TestServer
    @testserver = 'test.musicbrainz.org'
  end

  def teardown
  end
  
  def test_get_success
    ws = Webservice::Webservice.new(:host => @testserver)
    assert_nothing_raised {
      ws.get(:artist, Model::MBID.from_uuid(:artist, '10bf95b6-30e3-44f1-817f-45762cdc0de0'))
    }
  end
  
  # 400 - Bad Request
  def test_get_request_error
    ws = Webservice::Webservice.new(:host => @testserver)
    assert_raise(Webservice::RequestError) {
      ws.get(:artist, Model::MBID.from_uuid(:artist, '10bf95b6-30e3-44f1-817f-45762cdc0de0'),
             :include => 'inc=invalid')
    }
  end
  
  # 401 - Unauthorized
  # Not implemented, yet.
  #def test_get_authentication_error
  #  ws = Webservice::Webservice.new(:host => @testserver)
  #  assert_raise(Webservice::AuthenticationError) {
  #  #...
  #  }
  #end
  
  # 404 - Not Found
  def test_get_resource_not_found_error
    ws = Webservice::Webservice.new(:host => @testserver, :path_prefix => '/invalid')
    assert_raise(Webservice::ResourceNotFoundError) {
      ws.get(:artist, Model::MBID.from_uuid(:artist, '10bf95b6-30e3-44f1-817f-45762cdc0de0'))
    }
  end
  
  def test_get_connection_error
    ws = Webservice::Webservice.new(:host => 'example.org')
    ws.open_timeout = 0.1
    assert_raise(Webservice::ConnectionError) {
      ws.get(:artist, Model::MBID.from_uuid(:artist, '10bf95b6-30e3-44f1-817f-45762cdc0de0'))
    }
  end
  
end
