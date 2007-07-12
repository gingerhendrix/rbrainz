# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'rbrainz/webservice/includes'
require 'rbrainz/webservice/filter'
require 'net/http'

module MusicBrainz
  module Webservice

    class IWebservice
      
      # Query the Webservice with HTTP GET.
      # Must be implemented by the concrete webservices.
      def get(entity_type, options = {:id => nil, :include => nil, :filter => nil, :version => 1})
        raise NotImplementedError.new('Called abstract method.')
      end
      
      # Query the Webservice with HTTP POST.
      # Must be implemented by the concrete webservices.
      def post( entity_type, options={:id=>nil, :querystring=>[], :version=>1} )
        raise NotImplementedError.new('Called abstract method.')
      end
      
      def check_options(options, *optdecl)   #:nodoc:
        h = options.dup
        optdecl.each do |name|
          h.delete name
        end
        raise ArgumentError, "no such option: #{h.keys.join(' ')}" unless h.empty?
      end
      private :check_options
      
    end
    
    # Webservice class to query the default MusicBrainz server.
    class Webservice < IWebservice
    
      # Timeouts for opening and reading connections (in seconds)
      attr_accessor :open_timeout, :read_timeout
    
      # If no options are given the default MusicBrainz webservice will be used.
      # User authentication with username and password is only needed for some
      # services. If you want to query an alternative webservice you can do so
      # by setting the appropriate options.
      # 
      # Available options:
      # [:host] Host, defaults to 'musicbrainz.org'.
      # [:port] Port, defaults to 80.
      # [:path_prefix] The path prefix under which the webservice is located on
      #                the server. Defaults to '/ws'.
      # [:username] The username to authenticate with.
      # [:password] The password to authenticate with.
      # [:user_agent] Value sent in the User-Agent HTTP header. Defaults to 'rbrainz/2.0'
      def initialize(options = {:host => nil, :port => nil, :path_prefix => nil, :username=>nil, :password=>nil})
        check_options options, :host, :port, :path_prefix, :username, :password, :user_agent
        @host = options[:host] ? options[:host] : 'musicbrainz.org'
        @port = options[:port] ? options[:port] : 80
        @path_prefix = options[:path_prefix] ? options[:path_prefix] : '/ws'
        @username = options[:username]
        @password = options[:password]
        @user_agent = options[:user_agent] ? options[:user_agent] : 'rbrainz/2.0'
        @open_timeout = nil
        @read_timeout = nil
      end
    
      # Query the Webservice with HTTP GET.
      # 
      # Raises: +RequestError+, +ResourceNotFoundError+, +AuthenticationError+,
      # +ConnectionError+ 
      def get(entity_type, options = {:id => nil, :include => nil, :filter => nil, :version => 1})
        check_options options, :id, :include, :filter, :version
        url = URI.parse(create_uri(entity_type, options))
        request = Net::HTTP::Get.new(url.request_uri)
        request['User-Agent'] = @user_agent
        connection = Net::HTTP.new(url.host, url.port)
        
        # Set timeouts
        connection.open_timeout = @open_timeout if @open_timeout
        connection.read_timeout = @read_timeout if @read_timeout
        
        # Make the request
        begin
          response = connection.start do |http|
            response = http.request(request)
            if response.is_a?(Net::HTTPUnauthorized) && @username && @password
              request = Net::HTTP::Get.new(url.request_uri)
              request['User-Agent'] = @user_agent
              request.digest_auth @username, @password, response
              response = http.request(request)
            end
            response
          end
        rescue Timeout::Error, Errno::ETIMEDOUT
          raise ConnectionError.new('%s timed out' % url.to_s)
        end
        
        # Handle response errors.
        if response.is_a? Net::HTTPBadRequest # 400
          raise RequestError.new(url.to_s)
        elsif response.is_a? Net::HTTPUnauthorized # 401
          raise AuthenticationError.new(url.to_s)
        elsif response.is_a? Net::HTTPNotFound # 404
          raise ResourceNotFoundError.new(url.to_s)
        elsif response.is_a? Net::HTTPForbidden 
          raise AuthenticationError.new(url.to_s)
        elsif not response.is_a? Net::HTTPSuccess
          raise ConnectionError.new(response.class.name)
        end
        
        return response.body
      end
      
      # Send data to the web service via HTTP-POST.
      #
      # Note that this may require authentication. You can set
      # user name, password and realm in the constructor.
      #
      # Raises: +ConnectionError+, +RequestError+, +AuthenticationError+, 
      # +ResourceNotFoundError+
      #
      # == See
      # +IWebService.post+
      #
      def post( entity_type, options={:id=>nil, :querystring=>[], :version=>1} )
        check_options options, :id, :querystring, :version
        url = URI.parse(create_uri(entity_type, options))
        request = Net::HTTP::Post.new(url.request_uri)
        request['User-Agent'] = @user_agent
        request.set_form_data(options[:querystring])
        connection = Net::HTTP.new(url.host, url.port)
        
        # Set timeouts
        connection.open_timeout = @open_timeout if @open_timeout
        connection.read_timeout = @read_timeout if @read_timeout
        
        # Make the request
        begin
          response = connection.start do |http|
            response = http.request(request)
            
            if response.is_a?(Net::HTTPUnauthorized) && @username && @password
              request = Net::HTTP::Post.new(url.request_uri)
              request['User-Agent'] = @user_agent
              request.digest_auth @username, @password, response
              request.set_form_data(options[:querystring])
              response = http.request(request)
            end
            response
          end
        rescue Timeout::Error, Errno::ETIMEDOUT
          raise ConnectionError.new('%s timed out' % url.to_s)
        end
        
        # Handle response errors.
        if response.is_a? Net::HTTPBadRequest # 400
          raise RequestError.new(url.to_s)
        elsif response.is_a? Net::HTTPUnauthorized # 401
          raise AuthenticationError.new(url.to_s)
        elsif response.is_a? Net::HTTPNotFound # 404
          raise ResourceNotFoundError.new(url.to_s)
        elsif response.is_a? Net::HTTPForbidden 
          raise AuthenticationError.new(url.to_s)
        elsif not response.is_a? Net::HTTPSuccess
          raise ConnectionError.new(response.class.name)
        end
        
        return response.body
      end
      
      private # ----------------------------------------------------------------
      
      # Builds a request URI for querying the webservice.
      def create_uri(entity_type, options = {:id => nil, :include => nil, :filter => nil, :version => 1})
        # Make sure the version is set
        options[:version] = 1 if options[:version].nil?
        
        # Build the URI
        if options[:id]
          # Make sure the id is a MBID object
          id = options[:id]
          unless id.is_a? Model::MBID
            id = Model::MBID.parse(id, entity_type)
          end
        
          uri = 'http://%s:%d%s/%d/%s/%s?type=%s' %
                [@host, @port, @path_prefix, options[:version],
                 entity_type, id.uuid, 'xml']
        else
          uri = 'http://%s:%d%s/%d/%s/?type=%s' %
                [@host, @port, @path_prefix, options[:version],
                 entity_type, 'xml']
        end
        uri += '&' + options[:include].to_s unless options[:include].nil?
        uri += '&' + options[:filter].to_s unless options[:filter].nil?
        return uri
      end
    
    end
    
  end
end
