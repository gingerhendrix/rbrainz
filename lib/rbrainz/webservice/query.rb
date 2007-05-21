# $Id$
# Copyright (c) 2007, Philipp Wolfer
# All rights reserved.
# See LICENSE for permissions.

require 'rbrainz/webservice/webservice'
require 'rbrainz/webservice/mbxml'

module MusicBrainz
  module Webservice

    class Query
    
      def initialize(webservice = nil)
        @webservice = webservice.nil? ? Webservice.new : webservice
      end
      
      def get_artist_by_id(id, include = nil)
        xml = @webservice.get(Model::Artist.entity_type, id, :include => include)
        return MBXML.new(xml).get_entity(Model::Artist.entity_type)
      end
      
      # TODO: implement
      def get_artists(filter)
        raise NotImplementedError.new
      end
      
      def get_release_by_id(id, include = nil)
        xml = @webservice.get(Model::Release.entity_type, id, :include => include)
        return MBXML.new(xml).get_entity(Model::Release.entity_type)
      end
      
      # TODO: implement
      def get_releases(filter)
        raise NotImplementedError.new
      end
      
      def get_track_by_id(id, include = nil)
        xml = @webservice.get(Model::Track.entity_type, id, :include => include)
        return MBXML.new(xml).get_entity(Model::Track.entity_type)
      end
      
      # TODO: implement
      def get_tracks(filter)
        raise NotImplementedError.new
      end
      
      def get_label_by_id(id, include = nil)
        xml = @webservice.get(Model::Label.entity_type, id, :include => include)
        return MBXML.new(xml).get_entity(Model::Label.entity_type)
      end
      
      # TODO: implement
      def get_labels(filter)
        raise NotImplementedError.new
      end
      
    end

  end
end