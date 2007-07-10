# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'uri'

module MusicBrainz
  module Webservice

    # Base class for all filter classes.
    class AbstractFilter
      
      # The parameter +filter+ is a hash with filter options.
      # See the concrete classes for a description of those
      # options.
      # 
      # The following options are available for all filters:
      # [:limit]  The maximum number of entries returned. Defaults
      #           to 25, the maximum allowed value is 100.
      # [:offset] Return search results starting at a given offset. Used
      #           for paging through more than one page of results.
      def initialize(filter)
        @filter = Hash.new
        @filter[:limit]  = filter[:limit] if filter[:limit]
        @filter[:offset] = filter[:offset] if filter[:offset]
      end
      
      # Returns the filter list as a query string
      # (without leading +&+).
      def to_s
        @filter.to_a.map {|name, value|
          '%s=%s' % [URI.escape(name.to_s), URI.escape(value.to_s)]
        }.join('&')
      end
      
    end
    
    class ArtistFilter < AbstractFilter
    
      # The parameter +filter+ is a hash with filter options:
      # [:name]   Fetch a list of artists with a matching name.
      # [:limit]  The maximum number of artists returned. Defaults
      #           to 25, the maximum allowed value is 100.
      # [:offset] Return search results starting at a given offset. Used
      #           for paging through more than one page of results.
      def initialize(filter)
        super(filter)
        @filter[:name] = filter[:name]  if filter[:name]
      end
    
    end
    
    class ReleaseFilter < AbstractFilter
    
      # The parameter +filter+ is a hash with filter options:
      # [:title]     Fetch a list of releases with a matching title.
      # [:discid]    Fetch all releases matching to the given DiscID.
      # [:artist]    The returned releases should match the given artist name.
      # [:artistid]  The returned releases should match the given artist ID
      #              (36 character ASCII representation). If this is given,
      #              the artist parameter is ignored.
      # [:releasetypes] The returned releases must match all of the given
      #                 release types. This is a list of space separated values
      #                 like Official, Bootleg, Album, Compilation, etc.
      # [:count]     Number of tracks in the release.
      # [:date]      Earliest release date for the release.
      # [:asin]      The Amazon ASIN.
      # [:lang]      The language for this release.
      # [:script]    The script used in this release.
      # [:limit]     The maximum number of tracks returned. Defaults
      #              to 25, the maximum allowed value is 100. 
      # [:offset]    Return search results starting at a given offset. Used
      #              for paging through more than one page of results.
      def initialize(filter)
        super(filter)
        @filter[:title]        = filter[:title]     if filter[:title]
        @filter[:discid]       = filter[:discid]    if filter[:discid]
        @filter[:artist]       = filter[:artist]    if filter[:artist]
        @filter[:artistid]     = filter[:artistid]  if filter[:artistid]
        @filter[:releasetypes] = filter[:releasetypes] if filter[:releasetypes]
        @filter[:count]        = filter[:count]     if filter[:count]
        @filter[:date]         = filter[:date]      if filter[:date]
        @filter[:asin]         = filter[:asin]      if filter[:asin]
        @filter[:lang]         = filter[:lang]      if filter[:lang]
        @filter[:script]       = filter[:script]    if filter[:script]
      end
    
    end
    
    class TrackFilter < AbstractFilter
    
      # The parameter +filter+ is a hash with filter options:
      # [:title]     Fetch a list of tracks with a matching title.
      # [:artist]    The returned tracks have to match the given
      #              artist name.
      # [:release]   The returned tracks have to match the given
      #              release title.
      # [:duration]  The length of the track in milliseconds
      # [:tracknum]  The track number
      # [:artistid]  The artist's MBID. If this is given, the artist
      #              parameter is ignored.
      # [:releaseid] The release's MBID. If this is given, the release
      #              parameter is ignored.
      # [:puid]      The returned tracks have to match the given PUID.
      # [:count]     Number of tracks on the release.
      # [:releasetype] The type of the release this track appears on
      # [:limit]     The maximum number of tracks returned. Defaults
      #              to 25, the maximum allowed value is 100. 
      # [:offset]    Return search results starting at a given offset. Used
      #              for paging through more than one page of results.
      def initialize(filter)
        super(filter)
        @filter[:title]       = filter[:title]     if filter[:title]
        @filter[:artist]      = filter[:artist]    if filter[:artist]
        @filter[:release]     = filter[:release]   if filter[:release]
        @filter[:duration]    = filter[:duration]  if filter[:duration]
        @filter[:tracknum]    = filter[:tracknum]  if filter[:tracknum]
        @filter[:artistid]    = filter[:artistid]  if filter[:artistid]
        @filter[:releaseid]   = filter[:releaseid] if filter[:releaseid]
        @filter[:puid]        = filter[:puid]      if filter[:puid]
        @filter[:count]       = filter[:count]     if filter[:count]
        @filter[:releasetype] = filter[:releasetype] if filter[:releasetype]
      end
    
    end
    
    class LabelFilter < AbstractFilter
    
      # The parameter +filter+ is a hash with filter options:
      # [:name]   Fetch a list of labels with a matching name.
      # [:limit]  The maximum number of labels returned. Defaults
      #           to 25, the maximum allowed value is 100. 
      # [:offset] Return search results starting at a given offset. Used
      #           for paging through more than one page of results.
      def initialize(filter)
        super(filter)
        @filter[:name] = filter[:name]  if filter[:name]
      end
    
    end
    
    class UserFilter
      def initialize(name=nil)
        @filter = Hash.new
        @filter[:name] = name if name
      end
      
      # Returns the filter list as a query string
      # (without leading +&+).
      def to_s
        @filter.to_a.map {|name, value|
          '%s=%s' % [URI.escape(name.to_s), URI.escape(value.to_s)]
        }.join('&')
      end
    end
  end
end