# $Id$
# Copyright (c) 2007, Philipp Wolfer
# All rights reserved.
# See LICENSE for permissions.

require 'rbrainz/model/individual'
require 'rbrainz/model/alias'

module MusicBrainz
  module Model

    # An artist in the MusicBrainz DB.
    # 
    # See http://musicbrainz.org/doc/Artist.
    class Artist < Individual
    
      TYPE_PERSON = NS_MMD_1 + 'Person'
      TYPE_GROUP  = NS_MMD_1 + 'Group'
      
      attr_reader :aliases, :releases
                    
      def initialize
        super
        @aliases = Array.new
        @releases = Array.new
      end
      
    end

  end
end