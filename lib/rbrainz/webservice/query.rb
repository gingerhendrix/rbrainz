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
    class Query
    
      # Create a new Query object.
      # 
      # You can pass a custom Webservice[link:classes/MusicBrainz/Webservice/Webservice.html]
      # object. If none is given a default webservice will be used.
      def initialize(webservice = nil)
        @webservice = webservice.nil? ? Webservice.new : webservice
      end
      
      def get_artist_by_id(id, include = nil)
        return get_entity_by_id(Model::Artist.entity_type, id, include)
      end
      
      def get_artists(filter)
        return get_entities(Model::Artist.entity_type, filter)
      end
      
      def get_release_by_id(id, include = nil)
        return get_entity_by_id(Model::Release.entity_type, id, include)
      end
      
      def get_releases(filter)
        return get_entities(Model::Release.entity_type, filter)
      end
      
      def get_track_by_id(id, include = nil)
        return get_entity_by_id(Model::Track.entity_type, id, include)
      end
      
      def get_tracks(filter)
        return get_entities(Model::Track.entity_type, filter)
      end
      
      def get_label_by_id(id, include = nil)
        return get_entity_by_id(Model::Label.entity_type, id, include)
      end
      
      def get_labels(filter)
        return get_entities(Model::Label.entity_type, filter)
      end
      
      def get_user_by_name(name)
        xml = @webservice.get(:user, :filter => UserFilter.new(name))
        collection = MBXML.new(xml).get_entity_list(:user, Model::NS_EXT_1)
        return collection ? collection[0].entity : nil
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