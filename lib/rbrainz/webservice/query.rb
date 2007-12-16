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

    # A simple interface to the MusicBrainz web service.
    # 
    # This is a facade which provides a simple interface to the MusicBrainz
    # web service. It hides all the details like fetching data from a server,
    # parsing the XML and creating an object tree. Using this class, you can
    # request data by ID or search the _collection_ of all resources
    # (artists, labels, releases or tracks) to retrieve those matching given
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
    # In most cases, creating a Query object is as simple as this:
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
    #     :host     => 'test.musicbrainz.org',
    #     :username => 'whatever', 
    #     :password => 'secret'
    #   )
    #   q = MusicBrainz::Webservice::Query.new(service)
    # 
    # 
    # == Querying for Individual Resources
    # 
    # If the MusicBrainz ID of a resource is known, then the get_artist_by_id,
    # get_label_by_id, get_release_by_id or get_track_by_id method can be used
    # to retrieve it.
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
    #   Tori Amos
    #   Amos, Tori
    #   http://musicbrainz.org/ns/mmd-1.0#Person
    # 
    # This returned just the basic artist data, however. To get more detail
    # about a resource, the _includes_ parameters may be used 
    # which expect an ArtistIncludes, ReleaseIncludes, TrackIncludes or
    # LabelIncludes object, depending on the resource type.
    # It is also possible to use a Hash for the _includes_ parameter where it
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
    #   Tales of a Librarian
    #   Tori Amos
    #   Precious Things
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
    # get_tracks methods. The collections are huge, so you have to
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
    #   Under the Pink
    #   
    # 
    # The query returns a list of results in a ScoredCollection, 
    # which orders entities by score, with a higher score
    # indicating a better match. Note that those results don't contain
    # all the data about a resource. If you need more detail, you can then
    # use the get_artist_by_id, get_label_by_id, get_release_by_id, or
    # get_track_by_id methods to request the resource.
    # 
    # All filters support the _limit_ argument to limit the number of
    # results returned. This defaults to 25, but the server won't send
    # more than 100 results to save bandwidth and processing power. In case
    # you want to retrieve results above the 100 results limit you can use the
    # _offset_ argument in the filters. The _offset_ specifies how many entries
    # at the beginning of the collection should be skipped.
    # 
    class Query
    
      # Create a new Query object.
      # 
      # You can pass a custom Webservice[link:classes/MusicBrainz/Webservice/Webservice.html]
      # object. If none is given a default webservice will be used.
      #
      # If the constructor is called without arguments, an instance
      # of WebService is used, preconfigured to use the MusicBrainz
      # server. This should be enough for most users.
      #
      # If you want to use queries which require authentication you
      # have to pass a Webservice instance where user name and
      # password have been set.
      #
      # The _client_id_ option is required for data submission.
      # The format is <em>'application-version'</em>, where _application_
      # is your application's name and _version_ is a version
      # number which may not include a '-' character.
      #
      # Available options:
      # [:client_id] a unicode string containing the application's ID.
      # [:factory]   A model factory. An instance of Model::DefaultFactory
      #              will be used if none is given.
      def initialize(webservice = nil, options={ :client_id=>nil, :factory=>nil })
        Utils.check_options options, :client_id, :factory
        @webservice = webservice.nil? ? Webservice.new : webservice
        @client_id  = options[:client_id] ? options[:client_id] : nil
        @factory    = options[:factory] ? options[:factory] : nil
      end
      
      # Returns an artist.
      # 
      # The parameter _includes_ must be an instance of ArtistIncludes
      # or a options hash as expected by ArtistIncludes.
      # 
      # If no artist with that ID can be found, include contains invalid tags
      # or there's a server problem, and exception is raised.
      # 
      # Raises:: ConnectionError, RequestError, ResourceNotFoundError, ResponseError
      def get_artist_by_id(id, includes = nil)
        includes = ArtistIncludes.new(includes) unless includes.nil? || includes.is_a?(ArtistIncludes)
        return get_entity_by_id(Model::Artist.entity_type, id, includes)
      end
      
      # Returns artists matching given criteria.
      # 
      # The parameter _filter_ must be an instance of ArtistFilter
      # or a options hash as expected by ArtistFilter.
      # 
      # Raises:: ConnectionError, RequestError, ResponseError
      def get_artists(filter)
        filter = ArtistFilter.new(filter) unless filter.nil? || filter.is_a?(ArtistFilter)
        return get_entities(Model::Artist.entity_type, filter)
      end
      
      # Returns an release.
      # 
      # The parameter _includes_ must be an instance of ReleaseIncludes
      # or a options hash as expected by ReleaseIncludes.
      # 
      # If no release with that ID can be found, include contains invalid tags
      # or there's a server problem, and exception is raised.
      # 
      # Raises:: ConnectionError, RequestError, ResourceNotFoundError, ResponseError
      def get_release_by_id(id, includes = nil)
        includes = ReleaseIncludes.new(includes) unless includes.nil? || includes.is_a?(ReleaseIncludes)
        return get_entity_by_id(Model::Release.entity_type, id, includes)
      end
      
      # Returns releases matching given criteria.
      # 
      # The parameter _filter_ must be an instance of ReleaseFilter
      # or a options hash as expected by ReleaseFilter.
      # 
      # Raises:: ConnectionError, RequestError, ResponseError
      def get_releases(filter)
        filter = ReleaseFilter.new(filter) unless filter.nil? || filter.is_a?(ReleaseFilter)
        return get_entities(Model::Release.entity_type, filter)
      end
      
      # Returns an track.
      # 
      # The parameter _includes_ must be an instance of TrackIncludes
      # or a options hash as expected by TrackIncludes.
      # 
      # If no track with that ID can be found, include contains invalid tags
      # or there's a server problem, and exception is raised.
      # 
      # Raises:: ConnectionError, RequestError, ResourceNotFoundError, ResponseError
      def get_track_by_id(id, includes = nil)
        includes = TrackIncludes.new(includes) unless includes.nil? || includes.is_a?(TrackIncludes)
        return get_entity_by_id(Model::Track.entity_type, id, includes)
      end
      
      # Returns tracks matching given criteria.
      # 
      # The parameter _filter_ must be an instance of TrackFilter
      # or a options hash as expected by TrackFilter.
      # 
      # Raises:: ConnectionError, RequestError, ResponseError
      def get_tracks(filter)
        filter = TrackFilter.new(filter) unless filter.nil? || filter.is_a?(TrackFilter)
        return get_entities(Model::Track.entity_type, filter)
      end
      
      # Returns an label.
      # 
      # The parameter _includes_ must be an instance of LabelIncludes
      # or a options hash as expected by LabelIncludes.
      # 
      # If no label with that ID can be found, include contains invalid tags
      # or there's a server problem, and exception is raised.
      # 
      # Raises:: ConnectionError, RequestError, ResourceNotFoundError, ResponseError
      def get_label_by_id(id, includes = nil)
        includes = LabelIncludes.new(includes) unless includes.nil? || includes.is_a?(LabelIncludes)
        return get_entity_by_id(Model::Label.entity_type, id, includes)
      end
      
      # Returns labels matching given criteria.
      # 
      # The parameter _filter_ must be an instance of LabelFilter
      # or a options hash as expected by LabelFilter.
      # 
      # Raises:: ConnectionError, RequestError, ResponseError
      def get_labels(filter)
        filter = LabelFilter.new(filter) unless filter.nil? || filter.is_a?(LabelFilter)
        return get_entities(Model::Label.entity_type, filter)
      end
      
      # Returns information about a MusicBrainz user.
      # 
      # You can only request user data if you know the user name and password
      # for that account. If username and/or password are incorrect, an
      # AuthenticationError is raised.
      # 
      # See the example in Query on how to supply user name and password.
      # 
      # Raises:: ConnectionError, RequestError, AuthenticationError, ResponseError
      def get_user_by_name(name)
        xml = @webservice.get(:user, :filter => UserFilter.new(name))
        collection = MBXML.new(xml).get_entity_list(:user, Model::NS_EXT_1)
        unless collection and collection.size > 0
          raise ResponseError("response didn't contain user data")
        else
          return collection[0].entity
        end
      end
      
      # Submit track to PUID mappings.
      #
      # The <em>tracks2puids</em> parameter has to be a Hash or Array
      # with track ID/PUID pairs. The track IDs are either instances of MBID,
      # absolute URIs or the 36 character ASCII representation. PUIDs are 
      # 36 characters ASCII strings.
      # 
      # Example:
      #  ws = Webservice::Webservice.new(
      #         :host     => 'test.musicbrainz.org',
      #         :username => 'outsidecontext',
      #         :password => 'secret'
      #  ) 
      #  
      #  query = Webservice::Query.new(ws, :client_id=>'My Tagging App 1.0')
      #  
      #  query.submit_puids([
      #    ['90a56b15-4259-4a33-be13-20d5513504d5', '09ff336b-79e7-1303-f613-7f1cd0d5a346'],
      #    ['90a56b15-4259-4a33-be13-20d5513504d5', '18fd245f-bc0c-3361-9d61-61a225ed8c79'],
      #    ['6d9276af-b990-41b6-ad14-de2f128437ea', '3b633298-e671-957a-1f74-83fe71969ad0']
      #  ])
      #
      # Note that this method only works if a valid user name and
      # password have been set. If username and/or password are incorrect,
      # an AuthenticationError is raised. See the example in Query on
      # how to supply authentication data.
      #
      # See:: http://test.musicbrainz.org/doc/PUID
      # Raises:: ConnectionError, RequestError, AuthenticationError
      def submit_puids(tracks2puids)
        raise RequestError, 'Please supply a client ID' unless @client_id
        params = [['client', @client_id.to_s]] # Encoded as utf-8

        tracks2puids.each do |track_id, puid|
          track_id = Model::MBID.parse(track_id, :track).uuid
          params << ['puid', track_id + ' ' + puid ]
        end

        @webservice.post(:track, :params=>params)
      end
      
      # Submit tags for an entity. _mbid_ must be an instance of MBID identifying
      # the entity the tag should applied to and _tags_ is either and array or
      # Collection of Tag objects or a string with comma separated tags.
      # 
      # Note that this method only works if a valid user name and password have
      # been set. The tags will be applied for the authenticated user. If
      # username and/or password are incorrect, an AuthenticationError is raised.
      # See the example in Query on how to supply authentication data.
      #
      # Example:
      #  ws = Webservice::Webservice.new(
      #         :host     => 'test.musicbrainz.org',
      #         :username => 'outsidecontext',
      #         :password => 'secret'
      #  ) 
      #  
      #  query = Webservice::Query.new(ws)
      #
      #  mbid = Model::MBID.new('http://musicbrainz.org/artist/10bf95b6-30e3-44f1-817f-45762cdc0de0')
      #  query.submit_user_tags(mbid, 'doom metal, british')
      # 
      # See:: Model::Tag
      # Raises:: ConnectionError, RequestError, AuthenticationError
      def submit_user_tags(mbid, tags)
        mbid = Model::MBID.parse(mbid)
        tag_string = tags.respond_to?(:to_ary) ? tags.to_ary.join(',') : tags.to_s
        params = {:entity=>mbid.entity, :id=>mbid.uuid, :tags=>tag_string}
        @webservice.post(:tag, :params=>params)
      end
      
      # Returns a Model::Collection of tags a user has applied to the entity
      # identified by _mbid_.
      # 
      # Note that this method only works if a valid user name and password have
      # been set. Only the tags the authenticated user apllied to the entity will
      # be returned. If username and/or password are incorrect, an
      # AuthenticationError is raised. See the example in Query on how to supply
      # authentication data.
      #
      # Example:
      #  ws = Webservice::Webservice.new(
      #         :host     => 'test.musicbrainz.org',
      #         :username => 'outsidecontext',
      #         :password => 'secret'
      #  ) 
      #  
      #  query = Webservice::Query.new(ws)
      #
      #  mbid = Model::MBID.new('http://musicbrainz.org/artist/10bf95b6-30e3-44f1-817f-45762cdc0de0')
      #  query.get_user_tags(mbid)
      # 
      # See:: Model::Tag
      # Raises:: ConnectionError, RequestError, ResponseError, AuthenticationError
      def get_user_tags(mbid)
        mbid = Model::MBID.parse(mbid)
        return get_entities(:tag, "entity=#{mbid.entity}&id=#{mbid.uuid}").to_collection
      end
      
      private # ----------------------------------------------------------------
      
      # Helper method which will return any entity by ID.
      # 
      # Raises:: ConnectionError, RequestError, ResourceNotFoundError, ResponseError
      def get_entity_by_id(entity_type, id, includes)
        stream = @webservice.get(entity_type, :id => id, :include => includes)
        begin
          entity = MBXML.new(stream, @factory).get_entity(entity_type)
        rescue MBXML::ParseError => e
          raise ResponseError.new(e.to_s)
        end
        unless entity
          raise ResponseError.new("server didn't return #{entity_type.to_s} with the MBID #{id.to_s}")
        else
          return entity
        end
      end
      
      # Helper method which will search for the given entity type.
      # 
      # Raises:: ConnectionError, RequestError, ResponseError
      def get_entities(entity_type, filter)
        stream = @webservice.get(entity_type, :filter => filter)
        begin
          collection = MBXML.new(stream, @factory).get_entity_list(entity_type)
        rescue MBXML::ParseError => e
          raise ResponseError.new(e.to_s)
        end
        return collection
      end
      
    end

  end
end