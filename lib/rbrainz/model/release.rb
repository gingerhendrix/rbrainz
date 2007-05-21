# $Id$
# Copyright (c) 2007, Philipp Wolfer
# All rights reserved.
# See LICENSE for permissions.

require 'rbrainz/model/entity'
require 'rbrainz/model/release_event'
require 'set'

module MusicBrainz
  module Model

    # A release in the MusicBrainz DB.
    # 
    # See http://musicbrainz.org/doc/Release.
    #
    # TODO: Define constants for the release types
    # TODO: implement type list
    # TODO: implement language information
    class Release < Entity
    
      attr_accessor :title, :type_list, :language_information,
                    :asin, :artist
                    
      attr_accessor :tracks, :release_events
      
      def initialize
        @tracks = Set.new
        @release_events = Set.new
      end
      
    end
    
  end    
end