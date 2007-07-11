# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'uri'

module MusicBrainz
  module Webservice

    # Base class for all include classes.
    class AbstractIncludes
    
      def initialize(includes)
        raise 'Tried to initialize abstract class.'
      end 
      
      def to_s
        if @parameters.size > 0
          return 'inc=' + URI.escape(@parameters.join(' '))
        else
          return ''
        end
      end
    
    end
    
    class ArtistIncludes < AbstractIncludes
    
      # Includes is a hash with the following fields:
      # [:aliases]      Include aliases (boolean).
      # [:releases]     Array of release types that should be included
      #                 in the result. All releases of the artist that match
      #                 all of those types will be included. Use the constants
      #                 defined in Model::Releases for the release types.
      # [:va_releases]  Array of release types. All various artist releases
      #                 the artist appears on and that match all of those
      #                 types will be included. Use the constants
      #                 defined in Model::Releases for the release types.
      # [:artist_rels]  Include artist relationships (boolean).
      # [:release_rels] Include release relationships (boolean).
      # [:track_rels]   Include track relationships (boolean).
      # [:label_rels]   Include label relationships (boolean).
      # [:url_rels]     Include url relationships (boolean).
      # [:tags]         Include tags (boolean).
      # 
      # TODO: Check release types. It's possible that :releases
      # and :va_releases can't be used in parallel.
      def initialize(includes)
        @parameters = Array.new
        @parameters << 'aliases'      if includes[:aliases]
        @parameters << 'artist-rels'  if includes[:artist_rels]
        @parameters << 'release-rels' if includes[:release_rels]
        @parameters << 'track-rels'   if includes[:track_rels]
        @parameters << 'label-rels'   if includes[:label_rels]
        @parameters << 'url-rels'     if includes[:url_rels]
        @parameters << 'tags'         if includes[:tags]
        
        includes[:releases].each {|release_type|
          @parameters << 'sa-' + release_type.to_s
        } if includes[:releases]
        
        includes[:va_releases].each {|release_type|
          @parameters << 'va-' + release_type.to_s
        } if includes[:va_releases]
      end
      
    end
    
    class ReleaseIncludes < AbstractIncludes
    
      # Includes is a hash with the following fields:
      # [:artist]       Include track artist (boolean).
      # [:counts]       Includes the track number (boolean).
      # [:release_events] Includes the release events (boolean).
      # [:discs]        Include the disc IDs (boolean).
      # [:tracks]       Include the release tracks (boolean).
      # [:labels]       Include the labels under which the release
      #                 was published (boolean).
      # [:artist_rels]  Include artist relationships (boolean).
      # [:release_rels] Include release relationships (boolean).
      # [:track_rels]   Include track relationships (boolean).
      # [:label_rels]   Include label relationships (boolean).
      # [:url_rels]     Include url relationships (boolean).
      # [:track_level_rels] Include the relationships for the
      #                     single tracks as well (boolean).
      # [:tags]         Include tags (boolean).
      def initialize(includes)
        @parameters = Array.new
        @parameters << 'artist'       if includes[:artist]
        @parameters << 'counts'       if includes[:counts]
        @parameters << 'release-events' if includes[:release_events]
        @parameters << 'discs'        if includes[:discs]
        @parameters << 'tracks'       if includes[:tracks]
        @parameters << 'labels'       if includes[:labels]
        @parameters << 'artist-rels'  if includes[:artist_rels]
        @parameters << 'release-rels' if includes[:release_rels]
        @parameters << 'track-rels'   if includes[:track_rels]
        @parameters << 'label-rels'   if includes[:label_rels]
        @parameters << 'url-rels'     if includes[:url_rels]
        @parameters << 'track-level-rels' if includes[:track_level_rels]
        @parameters << 'tags'         if includes[:tags]
      end
    
    end
    
    class TrackIncludes < AbstractIncludes
    
      # Includes is a hash with the following fields:
      # [:artist]       Include track artist (boolean).
      # [:releases]     Includes releases the track appears on (boolean).
      # [:puids]        Include the track's PUIDs (boolean).
      # [:artist_rels]  Include artist relationships (boolean).
      # [:release_rels] Include release relationships (boolean).
      # [:track_rels]   Include track relationships (boolean).
      # [:label_rels]   Include label relationships (boolean).
      # [:url_rels]     Include url relationships (boolean).
      # [:tags]         Include tags (boolean).
      def initialize(includes)
        @parameters = Array.new
        @parameters << 'artist'       if includes[:artist]
        @parameters << 'releases'     if includes[:releases]
        @parameters << 'puids'        if includes[:puids]
        @parameters << 'artist-rels'  if includes[:artist_rels]
        @parameters << 'release-rels' if includes[:release_rels]
        @parameters << 'track-rels'   if includes[:track_rels]
        @parameters << 'label-rels'   if includes[:label_rels]
        @parameters << 'url-rels'     if includes[:url_rels]
        @parameters << 'tags'         if includes[:tags]
      end
    
    end
    
    class LabelIncludes < AbstractIncludes
    
      # Includes is a hash with the following fields:
      # [:aliases]      Include aliases (boolean).
      # [:artist_rels]  Include artist relationships (boolean).
      # [:release_rels] Include release relationships (boolean).
      # [:track_rels]   Include track relationships (boolean).
      # [:label_rels]   Include label relationships (boolean).
      # [:url_rels]     Include url relationships (boolean).
      # [:tags]         Include tags (boolean).
      def initialize(includes)
        @parameters = Array.new
        @parameters << 'aliases'      if includes[:aliases]
        @parameters << 'artist-rels'  if includes[:artist_rels]
        @parameters << 'release-rels' if includes[:release_rels]
        @parameters << 'track-rels'   if includes[:track_rels]
        @parameters << 'label-rels'   if includes[:label_rels]
        @parameters << 'url-rels'     if includes[:url_rels]
        @parameters << 'tags'         if includes[:tags]
      end
    
    end
    
  end
end