# $Id$
# Copyright (c) 2007, Philipp Wolfer
# All rights reserved.
# See LICENSE for permissions.

require 'rbrainz/model/entity'
require 'rbrainz/model/alias'
require 'rbrainz/model/incomplete_date'

module MusicBrainz
  module Model

    # An artist in the MusicBrainz DB.
    # 
    # See http://musicbrainz.org/doc/Artist.
    class Artist < Entity
    
      # TODO: Maybe there's a better solution (different constants?)
      TYPES = {
        :Person => 'http://musicbrainz.org/ns/mmd-1.0#Person',
        :Group  => 'http://musicbrainz.org/ns/mmd-1.0#Group'
        }
    
      attr_accessor :name, :sort_name, :disambiguation,
                    :begin_date, :end_date
                    
      attr_accessor :aliases, :releases
                    
      attr_reader :type
      
      def initialize
        @aliases = Array.new
        @releases = Array.new
      end
      
      def type=(type)
        unless TYPES.value? type
          raise UnknownArtistTypeError.new(type.to_s)
        end
        @type = type
      end
      
    end

  end
end