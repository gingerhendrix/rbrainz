# $Id$
# Copyright (c) 2007, Philipp Wolfer
# All rights reserved.
# See LICENSE for permissions.

require 'rbrainz/webservice/includes'
require 'rbrainz/webservice/filter'
require 'net/http'

module MusicBrainz
  module Webservice

    class IWebservice
      
      # Query the Webservice with HTTP GET.
      # Must be implemented by the concrete webservices.
      def get(entity, id, options = {:include => nil, :filter => nil, :version => 1})
        raise Exception.new('Called abstract method.')
      end
      
      # Query the Webservice with HTTP POST.
      # Must be implemented by the concrete webservices.
      # TODO: Specify and implement in Webservice.
      def post
        raise Exception.new('Called abstract method.')
      end
      
    end
    
    # Webservice class to query the default MusicBrainz server.
    # TODO: Implement authorization.
    class Webservice < IWebservice
    
      def initialize(options = {:host => nil, :port => nil, :path_prefix => nil})
        @host = options[:host] ? options[:host] : 'musicbrainz.org'
        @port = options[:port] ? options[:port] : 80
        @path_prefix = options[:path_prefix] ? options[:path_prefix] : '/ws'
      end
    
      # Query the Webservice with HTTP GET.
      # TODO: Exception handling.
      def get(entity, id, options = {:include => nil, :filter => nil, :version => 1})
        url = URI.parse(create_uri(entity, id, options))
        req = Net::HTTP::Get.new(url.request_uri)
        res = Net::HTTP.start(url.host, url.port) {|http|
          http.request(req)
        }
        return res.body
      end
      
      private
      
      # Builds a request URI for querying the webservice.
      def create_uri(entity, id, options = {:include => nil, :filter => nil, :version => 1})
        # Make sure the version is set
        options[:version] = 1 if options[:version].nil?
        
        # Build the URI
        uri  = 'http://%s:%d%s/%d/%s/%s?type=%s' %
               [@host, @port, @path_prefix, options[:version], entity, id.uuid, 'xml']
        uri += '&' + options[:include].to_s unless options[:include].nil?
        uri += '&' + options[:filter].to_s unless options[:filter].nil?
        return uri
      end
    
    end
    
  end
end