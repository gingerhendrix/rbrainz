# $Id: includes.rb 158 2007-07-25 16:19:19Z phw $
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'cgi'

module MusicBrainz
  module Webservice

    # Base class for all include classes.
    # 
    # Includes are used to specify which detail information should be returned
    # for an entity search. There is one include class for each entity type.
    class AbstractIncludes
    
      def initialize(includes)
        raise 'Tried to initialize abstract class.'
      end 
      
      # Returns the includes as a parameter that can be used in a MusicBrainz
      # XML web service URI.
      def to_s
        if @parameters.size > 0
          return 'inc=' + CGI.escape(@parameters.join(' '))
        else
          return ''
        end
      end

    end
    
    # A specification on how much data to return with an artist.
    # 
    # The MusicBrainz server only supports some combinations of release types
    # for the releases and vaReleases include tags. At the moment, not more
    # than two release types should be selected, while one of them has to be
    # Release.TYPE_OFFICIAL, Release.TYPE_PROMOTION or Release.TYPE_BOOTLEG.
    class ArtistIncludes < AbstractIncludes
    
      # Includes is a hash with the following fields:
      # [:aliases]      Include aliases (boolean).
      # [:releases]     Array of release types that should be included
      #                 in the result. All releases of the artist that match
      #                 all of those types will be included. Use the constants
      #                 defined in Model::Release for the release types.
      # [:va_releases]  Array of release types. All various artist releases
      #                 the artist appears on and that match all of those
      #                 types will be included. Use the constants
      #                 defined in Model::Release for the release types.
      # [:artist_rels]  Include artist relationships (boolean).
      # [:release_rels] Include release relationships (boolean).
      # [:track_rels]   Include track relationships (boolean).
      # [:label_rels]   Include label relationships (boolean).
      # [:url_rels]     Include url relationships (boolean).
      # [:release_events] Include release events (boolean).
      # [:tags]         Include tags (boolean).
      # 
      #--
      # TODO:: Check release types. It's possible that :releases
      #        and :va_releases can't be used in parallel.
      #++
      def initialize(includes)
        Utils.check_options includes, 
          :aliases, :artist_rels, :release_rels, :track_rels, :release_events,
          :label_rels, :url_rels, :tags, :releases, :va_releases
        @parameters = Array.new
        @parameters << 'aliases'      if includes[:aliases]
        @parameters << 'artist-rels'  if includes[:artist_rels]
        @parameters << 'release-rels' if includes[:release_rels]
        @parameters << 'track-rels'   if includes[:track_rels]
        @parameters << 'label-rels'   if includes[:label_rels]
        @parameters << 'url-rels'     if includes[:url_rels]
        @parameters << 'release-events'   if includes[:release_events]
        @parameters << 'tags'         if includes[:tags]
        
        includes[:releases].each {|release_type|
          @parameters << 'sa-' + Utils.remove_namespace(release_type.to_s)
        } if includes[:releases]
        
        includes[:va_releases].each {|release_type|
          @parameters << 'va-' + Utils.remove_namespace(release_type.to_s)
        } if includes[:va_releases]
      end
      
    end
    
    # A specification on how much data to return with a release.
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
        Utils.check_options includes, 
            :artist, :counts, :release_events, :discs, :tracks, 
            :labels, :artist_rels, :release_rels, :track_rels, 
            :label_rels, :url_rels, :track_level_rels, :tags
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
    
    # A specification on how much data to return with a track.
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
        Utils.check_options includes, 
            :artist, :releases, :puids, :artist_rels, :release_rels, 
            :track_rels, :label_rels, :url_rels, :tags
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
    
    # A specification on how much data to return with a label.
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
        Utils.check_options includes, 
            :aliases, :artist_rels, :release_rels, 
            :track_rels, :label_rels, :url_rels, :tags
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
