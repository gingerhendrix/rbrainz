# $Id$
# Copyright (c) 2007, Philipp Wolfer
# All rights reserved.
# See LICENSE for permissions.

require 'rbrainz/model/individual'

module MusicBrainz
  module Model

    # A label in the MusicBrainz DB.
    # 
    # See http://musicbrainz.org/doc/Label.
    class Label < Individual
    
      TYPE_UNKNOWN             = NS_MMD_1 + 'Unknown'
      TYPE_DISTRIBUTOR         = NS_MMD_1 + 'Distributor'
      TYPE_HOLDING             = NS_MMD_1 + 'Holding'
      TYPE_ORIGINAL_PRODUCTION = NS_MMD_1 + 'OriginalProduction'
      TYPE_BOOTLEG_PRODUCTION  = NS_MMD_1 + 'BootlegProduction'
      TYPE_REISSUE_PRODUCTION  = NS_MMD_1 + 'ReissueProduction'
      
      attr_accessor :code, :country
      
      attr_reader :releases
      
      def initialize
        super
        @releases = Array.new
      end
      
    end
    
  end
end