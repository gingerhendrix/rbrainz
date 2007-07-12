# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'rbrainz/webservice/webservice'
require 'rbrainz/webservice/mbxml'

module MusicBrainz
  module Webservice

    # Provides an easy to use interface to the MusicBrainz webservice.
    # 
    # Basic usage:
    #  query = Webservice::Query.new
    #  
    #  artist_filter = Webservice::ArtistFilter.new(
    #    :name  => 'Paradise Lost',
    #    :limit => 10
    #  )
    #  
    #  artist_collection = query.get_artists(artist_filter)
    #  
    #  artists.each do |entry|
    #    print "%s (%i%%)\r\n" % [entry.entity.unique_name, entry.score]
    #  end
    #  
    # User authentication:
    #  ws = Webservice::Webservice.new(:username=>username, :password=>password)
    #  query = Webservice::Query.new(ws)
    #  user = query.get_user_by_name(username)



    # A simple interface to the MusicBrainz web service.
    # 
    # This is a facade which provides a simple interface to the MusicBrainz
    # web service. It hides all the details like fetching data from a server,
    # parsing the XML and creating an object tree. Using this class, you can
    # request data by ID or search the _collection_ of all resources
    # (artists, releases, or tracks) to retrieve those matching given
    # criteria. This document contains examples to get you started.
    # 
    # 
    # == Working with Identifiers
    # MusicBrainz uses absolute URIs as identifiers. For example, the artist
    # 'Tori Amos' is identified using the following URI:
    #   http://musicbrainz.org/artist/c0b2500e-0cef-4130-869d-732b23ed9df5
    # 
    # In some situations it is obvious from the context what type of 
    # resource an ID refers to. In these cases, abbreviated identifiers may
    # be used, which are just the _UUID_ part of the URI. Thus the ID above
    # may also be written like this:
    #   c0b2500e-0cef-4130-869d-732b23ed9df5
    # 
    # All methods in this class which require IDs accept both the absolute
    # URI and the abbreviated form (aka the relative URI).
    # 
    # 
    # == Creating a Query Object
    # 
    # In most cases, creating a +Query+ object is as simple as this:
    #   require 'rbrainz'
    #   q = MusicBrainz::Webservice::Query.new
    # 
    # The instantiated object uses the standard Webservice class to
    # access the MusicBrainz web service. If you want to use a different 
    # server or you have to pass user name and password because one of
    # your queries requires authentication, you have to create the
    # Webservice object yourself and configure it appropriately.
    # 
    # This example uses the MusicBrainz test server and also sets
    # authentication data:
    #   require 'rbrainz'
    #   service = MusicBrainz::Webservice::Webservice.new(
    #     :host=>'test.musicbrainz.org',
    #     :username=>'whatever', 
    #     :password=>'secret'
    #   )
    #   q = MusicBrainz::Webservice::Query.new(service)
    # 
    # 
    # == Querying for Individual Resources
    # 
    # If the MusicBrainz ID of a resource is known, then the get_artist_by_id,
    # get_release_by_id, or get_track_by_id method can be used to retrieve
    # it.
    # 
    # Example:
    #   require 'rbrainz'
    #   q = MusicBrainz::Webservice::Query.new
    #   artist = q.get_artist_by_id('c0b2500e-0cef-4130-869d-732b23ed9df5')
    #   puts artist.name
    #   puts artist.sort_name
    #   puts artist.type
    #   
    # _produces_:
    #   'Tori Amos'
    #   'Amos, Tori'
    #   http://musicbrainz.org/ns/mmd-1.0#Person
    # 
    # This returned just the basic artist data, however. To get more detail
    # about a resource, the +includes+ parameters may be used 
    # which expect an ArtistIncludes, ReleaseIncludes, TrackIncludes or
    # LabelIncludes object, depending on the resource type.
    # It is also possible to use a Hash for the +includes+ parameter where it
    # will then get automaticly wrapped in the appropriate includes class.
    # 
    # To get data about a release which also includes the main artist
    # and all tracks, for example, the following query can be used:
    #   require 'rbrainz'
    #   q = MusicBrainz::Webservice::Query.new
    #   release_id = '33dbcf02-25b9-4a35-bdb7-729455f33ad7'
    #   release = q.get_release_by_id(release_id, :artist=>true, :tracks=>true)
    #   puts release.title
    #   puts release.artist.name
    #   puts release.tracks[0].title
    # 
    # _produces_:
    #   'Tales of a Librarian'
    #   'Tori Amos'
    #   'Precious Things'
    # 
    # Note that the query gets more expensive for the server the more
    # data you request, so please be nice.
    # 
    # 
    # == Searching in Collections
    # 
    # For each resource type (artist, release, and track), there is one
    # collection which contains all resources of a type. You can search
    # these collections using the get_artists, get_releases, and
    # +get_tracks+ methods. The collections are huge, so you have to
    # use filters (ArtistFilter, ReleaseFilter, TrackFilter or LabelFilter)
    # to retrieve only resources matching given criteria.
    # As with includes it is also possible to use a Hash as the filter where
    # it will then get wrapped in the appropriate filter class.
    # 
    # For example, If you want to search the release collection for
    # releases with a specified DiscID, you would use get_releases:
    #   require 'rbrainz'
    #   q = MusicBrainz::Webservice::Query.new
    #   results = q.get_releases(ReleaseFilter.new(:disc_id=>discId='8jJklE258v6GofIqDIrE.c5ejBE-'))
    #   puts results[0].score
    #   puts results[0].entity.title
    # 
    # _produces_:
    #   100
    #   'Under the Pink'
    #   
    # 
    # The query returns a list of results in a ScoredCollection, 
    # which orders entities by score, with a higher score
    # indicating a better match. Note that those results don't contain
    # all the data about a resource. If you need more detail, you can then
    # use the get_artist_by_id, get_release_by_id, or get_track_by_id
    # methods to request the resource.
    # 
    # All filters support the +limit+ argument to limit the number of
    # results returned. This defaults to 25, but the server won't send
    # more than 100 results to save bandwidth and processing power.
    # 
    # 
    class Query
    
      # Create a new Query object.
      # 
      # You can pass a custom Webservice
      # object. If none is given a default webservice will be used.
      #
      # If the constructor is called without arguments, an instance
      # of WebService is used, preconfigured to use the MusicBrainz
      # server. This should be enough for most users.
      #
      # If you want to use queries which require authentication you
      # have to pass a +WebService+ instance where user name and
      # password have been set.
      #
      # The _client_id_ option is required for data submission.
      # The format is <em>'application-version'</em>, where _application_
      # is your application's name and _version_ is a version
      # number which may not include a '-' character.
      #
      # Available options:
      # [:client_id] a unicode string containing the application's ID
      def initialize(webservice = nil, options={})
        @webservice = webservice.nil? ? Webservice.new : webservice
        @client_id = options[:client_id] ? options[:client_id] : nil
      end
      
      def get_artist_by_id(id, includes = nil)
        includes = ArtistIncludes.new(includes) unless includes.is_a? ArtistIncludes
        return get_entity_by_id(Model::Artist.entity_type, id, includes)
      end
      
      def get_artists(filter)
        filter = ArtistFilter.new(filter) unless filter.is_a? ArtistFilter
        return get_entities(Model::Artist.entity_type, filter)
      end
      
      def get_release_by_id(id, includes = nil)
        includes = ReleaseIncludes.new(includes) unless includes.is_a? ReleaseIncludes
        return get_entity_by_id(Model::Release.entity_type, id, includes)
      end
      
      def get_releases(filter)
        filter = ReleaseFilter.new(filter) unless filter.is_a? ReleaseFilter
        return get_entities(Model::Release.entity_type, filter)
      end
      
      def get_track_by_id(id, includes = nil)
        includes = TrackIncludes.new(includes) unless includes.is_a? TrackIncludes
        return get_entity_by_id(Model::Track.entity_type, id, includes)
      end
      
      def get_tracks(filter)
        filter = TrackFilter.new(filter) unless filter.is_a? TrackFilter
        return get_entities(Model::Track.entity_type, filter)
      end
      
      def get_label_by_id(id, includes = nil)
        includes = LabelIncludes.new(includes) unless includes.is_a? LabelIncludes
        return get_entity_by_id(Model::Label.entity_type, id, includes)
      end
      
      def get_labels(filter)
        filter = LabelFilter.new(filter) unless filter.is_a? LabelFilter
        return get_entities(Model::Label.entity_type, filter)
      end
      
      def get_user_by_name(name)
        xml = @webservice.get(:user, :filter => UserFilter.new(name))
        collection = MBXML.new(xml).get_entity_list(:user, Model::NS_EXT_1)
        return collection ? collection[0].entity : nil
      end
      
      #
      # Submit track to PUID mappings.
      #
      # The C{tracks2puids} parameter has to be a dictionary, with the
      # keys being MusicBrainz track IDs (either as absolute URIs or
      # in their 36 character ASCII representation) and the values
      # being PUIDs (ASCII, 36 characters).
      #
      # Note that this method only works if a valid user name and
      # password have been set. See the example in L{Query} on how
      # to supply authentication data.
      #
      # Raises:: +ConnectionError+, +RequestError+, +AuthenticationError+
      def submit_puids(tracks2puids):
        raise RequestError, 'Please supply a client ID' unless @client_id
        params = [['client', @client_id.to_s]] # Encoded as utf-8

        tracks2puids.each {|track_id, puid| params << ['puid', track_id + ' ' + puid ]}

        @webservice.post('track', :querystring=>params)
      end
      
      private # ----------------------------------------------------------------
      
      # Helper method which will return any entity by ID.
      def get_entity_by_id(entity_type, id, include)
        xml = @webservice.get(entity_type, :id => id, :include => include)
        return MBXML.new(xml).get_entity(entity_type)
      end
      
      # Helper method which will search for the given entity type.
      def get_entities(entity_type, filter)
        xml = @webservice.get(entity_type, :filter => filter)
        return MBXML.new(xml).get_entity_list(entity_type)
      end
      
    end

  end
end