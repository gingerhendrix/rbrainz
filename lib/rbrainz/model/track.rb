# $Id$
# Copyright (c) 2007, Philipp Wolfer
# All rights reserved.
# See LICENSE for permissions.

require 'rbrainz/model/entity'
require 'set'

module MusicBrainz
  module Model

    # A track in the MusicBrainz DB.
    # 
    # See http://musicbrainz.org/doc/Track.
    class Track < Entity
    
      attr_accessor :title, :duration, :artist,
                    :puids, :releases
      
      def initialize
        @puids = Set.new
        @releases = Set.new
      end
      
    end

  end
end