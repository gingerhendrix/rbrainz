# $Id$
# Copyright (c) 2007, Philipp Wolfer
# All rights reserved.
# See LICENSE for permissions.

module MusicBrainz
  module Webservice

    # Connecting to the web service failed.
    #
    # This exception is raised if the connection to the server can not be
    # established due to networking problems (e.g. wrong port number or
    # server down).
    class ConnectionError < Exception
    end
    
    # An invalid request was made (invalid IDs or parameters).
    class RequestError < Exception
    end
    
    # Client requested a resource which requires authentication via HTTP
    # Digest Authentication.
    # 
    # If sent even though user name and password were given: user name and/or
    # password are incorrect. 
    class AuthenticationError < Exception
    end
    
    # The requested resource doesn't exist.
    class ResourceNotFoundError < Exception
    end
    
  end 
end

require 'rbrainz/webservice/query'