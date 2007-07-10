# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'rbrainz/webservice/webservice'
require 'rbrainz/webservice/mbxml'

module MusicBrainz
  module Webservice

    class Query
    
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
        MBXML.new(xml).get_entity_array(:user, Model::NS_EXT_1)[0]
      end
      
      private
      
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