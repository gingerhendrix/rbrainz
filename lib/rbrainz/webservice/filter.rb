# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'cgi'

module MusicBrainz
  module Webservice

    # Base class for all filter classes.
    # 
    # Filter classes are initialized with a set of criteria and are then
    # applied to collections of items. The criteria are usually strings
    # or integer values, depending on the filter.
    class AbstractFilter
      
      # The parameter _filter_ is a hash with filter options.
      # See the concrete classes for a description of those
      # options.
      # 
      # The following options are available for all filters:
      # [:limit]  The maximum number of entries returned. Defaults
      #           to 25, the maximum allowed value is 100.
      # [:offset] Return search results starting at a given offset. Used
      #           for paging through more than one page of results.
      # [:query]  A Lucene search query. The query parameter is a search
      #           string which will be passed to the underlying Lucene search
      #           engine. It must follow the syntax described in
      #           http://musicbrainz.org/doc/TextSearchSyntax.
      def initialize(filter)
        @filter = Hash.new
        @filter[:limit]  = filter[:limit]  if filter[:limit]
        @filter[:offset] = filter[:offset] if filter[:offset]
        @filter[:query]  = filter[:query]  if filter[:query]
      end
      
      # Returns the filter list as a query string (without leading <em>&</em>).
      def to_s
        @filter.to_a.map {|name, value|
          '%s=%s' % [CGI.escape(name.to_s), CGI.escape(value.to_s)]
        }.join('&')
      end
      
    end
    
    # A filter for the artist collection.
    class ArtistFilter < AbstractFilter
    
      # The parameter _filter_ is a hash with filter options. At least the
      # <tt>:name</tt> or <tt>:query</tt> filter must be specified.
      # 
      # Available filter options:
      # [:name]   Fetch a list of artists with a matching name.
      # [:limit]  The maximum number of artists returned. Defaults
      #           to 25, the maximum allowed value is 100.
      # [:offset] Return search results starting at a given offset. Used
      #           for paging through more than one page of results.
      # [:query]  A Lucene search query. The query parameter is a search
      #           string which will be passed to the underlying Lucene search
      #           engine. It must follow the syntax described in
      #           http://musicbrainz.org/doc/TextSearchSyntax.
      def initialize(filter)
        Utils.check_options filter, :name, :limit, :offset, :query
        super(filter)
        @filter[:name] = filter[:name]  if filter[:name]
      end
    
    end
    
    # A filter for the release collection.
    class ReleaseFilter < AbstractFilter
    
      # The parameter _filter_ is a hash with filter options. At least one
      # filter despite <tt>:limit</tt> and <tt>:offset</tt> must be specified.
      # 
      # Available filter options:
      # [:title]     Fetch a list of releases with a matching title.
      # [:discid]    Fetch all releases matching to the given DiscID.
      # [:artist]    The returned releases should match the given artist name.
      # [:artistid]  The returned releases should match the given artist ID
      #              (36 character ASCII representation). If this is given,
      #              the artist parameter is ignored.
      # [:releasetypes] The returned releases must match all of the given
      #                 release types. This is either an array of release types
      #                 as defined in Model::Release or a string of space separated
      #                 values like Official, Bootleg, Album, Compilation etc.
      # [:count]     Number of tracks in the release.
      # [:date]      Earliest release date for the release.
      # [:asin]      The Amazon ASIN.
      # [:lang]      The language for this release.
      # [:script]    The script used in this release.
      # [:limit]     The maximum number of tracks returned. Defaults
      #              to 25, the maximum allowed value is 100. 
      # [:offset]    Return search results starting at a given offset. Used
      #              for paging through more than one page of results.
      # [:query]     A Lucene search query. The query parameter is a search
      #              string which will be passed to the underlying Lucene search
      #              engine. It must follow the syntax described in
      #              http://musicbrainz.org/doc/TextSearchSyntax.
      def initialize(filter)
        Utils.check_options filter, 
          :limit, :offset, :query, :title, :discid, :artist, :artistid, 
          :releasetypes, :count, :date, :asin, :lang, :script
        super(filter)
        @filter[:title]        = filter[:title]     if filter[:title]
        @filter[:discid]       = filter[:discid]    if filter[:discid]
        @filter[:artist]       = filter[:artist]    if filter[:artist]
        @filter[:artistid]     = filter[:artistid]  if filter[:artistid]
        @filter[:count]        = filter[:count]     if filter[:count]
        @filter[:date]         = filter[:date]      if filter[:date]
        @filter[:asin]         = filter[:asin]      if filter[:asin]
        @filter[:lang]         = filter[:lang]      if filter[:lang]
        @filter[:script]       = filter[:script]    if filter[:script]
        
        if releasetypes = filter[:releasetypes]
          if releasetypes.respond_to?(:to_a)
            releasetypes = releasetypes.to_a.map do |type|
              Utils.remove_namespace(type)
            end.join(' ')
          end
          @filter[:releasetypes] = releasetypes
        end
      end
    
    end
    
    # A filter for the track collection.
    class TrackFilter < AbstractFilter
    
      # The parameter _filter_ is a hash with filter options. At least the
      # <tt>:title</tt>, <tt>:puid</tt> or <tt>:query</tt> filter must be specified.
      # 
      # Available filter options:
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
      # [:releasetype] The type of the release this track appears on. See
      #                Model::Release for possible values.
      # [:limit]     The maximum number of tracks returned. Defaults
      #              to 25, the maximum allowed value is 100. 
      # [:offset]    Return search results starting at a given offset. Used
      #              for paging through more than one page of results.
      # [:query]     A Lucene search query. The query parameter is a search
      #              string which will be passed to the underlying Lucene search
      #              engine. It must follow the syntax described in
      #              http://musicbrainz.org/doc/TextSearchSyntax.
      def initialize(filter)
        Utils.check_options filter, 
            :limit, :offset, :query, :title, :artist, :release, :duration, 
            :tracknum, :artistid, :releaseid, :puid, :count, :releasetype
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
        if filter[:releasetype]
          @filter[:releasetype] = Utils.remove_namespace(filter[:releasetype])
        end
      end
    
    end
    
    # A filter for the label collection.
    class LabelFilter < AbstractFilter
    
      # The parameter _filter_ is a hash with filter options. At least the
      # <tt>:name</tt> or <tt>:query</tt> filter must be specified.
      # 
      # Available filter options:
      # [:name]   Fetch a list of labels with a matching name.
      # [:limit]  The maximum number of labels returned. Defaults
      #           to 25, the maximum allowed value is 100. 
      # [:offset] Return search results starting at a given offset. Used
      #           for paging through more than one page of results.
      # [:query]  A Lucene search query. The query parameter is a search
      #           string which will be passed to the underlying Lucene search
      #           engine. It must follow the syntax described in
      #           http://musicbrainz.org/doc/TextSearchSyntax.
      def initialize(filter)
        Utils.check_options filter, :limit, :offset, :query, :name
        super(filter)
        @filter[:name] = filter[:name]  if filter[:name]
      end
    
    end
    
    # A filter to query a user by his username.
    class UserFilter
      def initialize(name=nil)
        @filter = Hash.new
        @filter[:name] = name if name
      end
      
      # Returns the filter list as a query string (without leading <em>&</em>).
      def to_s
        @filter.to_a.map {|name, value|
          '%s=%s' % [URI.escape(name.to_s), URI.escape(value.to_s)]
        }.join('&')
      end
    end
    
  end
end