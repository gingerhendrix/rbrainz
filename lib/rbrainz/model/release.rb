# $Id$
# Copyright (c) 2007, Philipp Wolfer
# All rights reserved.
# See LICENSE for permissions.

require 'rbrainz/model/entity'
require 'rbrainz/model/release_event'
require 'rbrainz/model/disc'

module MusicBrainz
  module Model

    # A release in the MusicBrainz DB.
    # 
    # See http://musicbrainz.org/doc/Release.
    class Release < Entity
    
      TYPE_ALBUM          = NS_MMD_1 + 'Album' 
      TYPE_AUDIOBOOK      = NS_MMD_1 + 'Audiobook' 
      TYPE_BOOTLEG        = NS_MMD_1 + 'Bootleg' 
      TYPE_COMPILATION    = NS_MMD_1 + 'Compilation' 
      TYPE_EP             = NS_MMD_1 + 'EP' 
      TYPE_INTERVIEW      = NS_MMD_1 + 'Interview' 
      TYPE_LIVE           = NS_MMD_1 + 'Live' 
      TYPE_NONE           = NS_MMD_1 + 'None' 
      TYPE_OFFICIAL       = NS_MMD_1 + 'Official' 
      TYPE_OTHER          = NS_MMD_1 + 'Other' 
      TYPE_PROMOTION      = NS_MMD_1 + 'Promotion' 
      TYPE_PSEUDO_RELEASE = NS_MMD_1 + 'Pseudo-Release' 
      TYPE_REMIX          = NS_MMD_1 + 'Remix' 
      TYPE_SINGLE         = NS_MMD_1 + 'Single' 
      TYPE_SOUNDTRACK     = NS_MMD_1 + 'Soundtrack' 
      TYPE_SPOKENWORD     = NS_MMD_1 + 'Spokenword' 
      
      attr_accessor :title, :types, :asin, :artist,
                    :text_language, :text_script
                    
      attr_accessor :tracks, :release_events, :discs
      
      def initialize
        super
        @tracks = Array.new
        @release_events = Array.new
        @discs = Array.new
        @types = Array.new
      end
      
    end
    
  end    
end