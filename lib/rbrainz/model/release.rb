# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'rbrainz/model/entity'
require 'rbrainz/model/release_event'
require 'rbrainz/model/disc'

module MusicBrainz
  module Model

    #
    # A release in the MusicBrainz DB.
    #
    # A release within MusicBrainz is an Entity which contains Track
    # objects.  Releases may be of more than one type: There can be albums,
    # singles, compilations, live recordings, official releases, bootlegs
    # etc.
    #
    # See:: http://musicbrainz.org/doc/Release.
    # Note:: The current MusicBrainz server implementation supports only a
    #        limited set of types.
    #
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
      
      # The title of this release.
      attr_accessor :title

      # The amazon shop identifier.
      #
      # The ASIN is a 10-letter code (except for books) assigned
      # by Amazon, which looks like 'B000002IT2' or 'B00006I4YD'.
      attr_accessor :asin

      # The main artist of this release.
      attr_accessor :artist

      # The language used in release and track titles.
      # 
      # To represent the language, the ISO-639-2/T standard is used,
      # which provides three-letter terminological language codes like
      # 'ENG', 'DEU', 'JPN', 'KOR', 'ZHO' or 'YID'.
      #
      # Note that this refers to release and track <i>titles</i>, not
      # lyrics.
      attr_accessor :text_language

      # The script used in release and track titles.
      #
      # To represent the script, ISO-15924 script codes are used.
      # Valid codes are, among others: 'Latn', 'Cyrl', 'Hans', 'Hebr'
      #
      # Note that this refers to release and track <i>titles</i>, not
      # lyrics.
      attr_accessor :text_script
                    
      # The list of tracks.
      attr_reader :tracks

      # The list of release events.
      #
      # A Release may contain a list of so-called release events,
      # each represented using a ReleaseEvent object. Release
      # events specify where and when this release was, well, released.
      attr_reader :release_events

      # The list of associated discs.
      #
      # Note that under rare circumstances (identical TOCs), a
      # Disc could be associated with more than one release.
      attr_reader :discs

      # The list of types for this release.
      #
      # To test for release types, you can use the constants
      # TYPE_ALBUM, TYPE_SINGLE, etc.
      attr_reader :types
      
      def initialize(id=nil, title=nil)
        super id
        @title  = title
        @tracks = Collection.new
        @release_events = Collection.new
        @discs  = Collection.new
        @types  = Array.new
      end

      #
      # Checks if this is a single artist's release.
      #
      # Returns +true+ if the release's main artist (#artist) is
      # also the main artist for all of the tracks. This is checked by
      # comparing the artist IDs.
      #
      # Note that the release's artist has to be set (see #artist=)
      # for this. The track artists may be unset.
      def single_artist_release?
          raise 'Release Artist may not be None!' unless artist
          tracks.all {|track| !track.artist || track.artist.id == artist.id }
      end
    
      # Returns the string representation for this individual.
      # 
      # Returns #title converted into a string.
      def to_s
        title.to_s
      end
      
    end
    
  end    
end