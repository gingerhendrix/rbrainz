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
    #        limited set of types. See http://wiki.musicbrainz.org/ReleaseAttribute
    #        for more information.
    class Release < Entity
    
      # A type for not a type. Currently unsupported by MusicBrainz
      TYPE_NONE           = NS_MMD_1 + 'None'
      
      # An album, perhaps better defined as a "Long Play" (LP) release,
      # generally consists of previously unreleased material. This includes
      # release re-issues, with or without bonus tracks.
      TYPE_ALBUM          = NS_MMD_1 + 'Album'
      # An audiobook is a book read by a narrator without music.
      TYPE_AUDIOBOOK      = NS_MMD_1 + 'Audiobook'
      # A compilation is a collection of previously released tracks by one or
      # more artists. Please note that this is a simplified description of a
      # compilation.
      TYPE_COMPILATION    = NS_MMD_1 + 'Compilation'
      # An EP is a so-called "Extended Play" release and often contains the
      # letters EP in the title.
      TYPE_EP             = NS_MMD_1 + 'EP'
      # An interview release contains an interview, generally with an Artist.
      TYPE_INTERVIEW      = NS_MMD_1 + 'Interview'
      # A release that was recorded live.
      TYPE_LIVE           = NS_MMD_1 + 'Live'
      # A release that primarily contains remixed material.
      TYPE_REMIX          = NS_MMD_1 + 'Remix'
      # A single typically has one main song and possibly a handful of
      # additional tracks or remixes of the main track. A single is usually
      # named after its main song.
      TYPE_SINGLE         = NS_MMD_1 + 'Single'
      # A soundtrack is the musical score to a movie, TV series, stage show,
      # computer game etc.
      TYPE_SOUNDTRACK     = NS_MMD_1 + 'Soundtrack'
      # Non-music spoken word releases.
      TYPE_SPOKENWORD     = NS_MMD_1 + 'Spokenword'
      # Any release that does not fit or can't decisively be placed in any of
      # the categories above.
      TYPE_OTHER          = NS_MMD_1 + 'Other'
      
      # Any release officially sanctioned by the artist and/or their record
      # company. (Most releases will fit into this category.)
      TYPE_OFFICIAL       = NS_MMD_1 + 'Official'
      # A giveaway release or a release intended to promote an upcoming official
      # release. (e.g. prerelease albums or releases included with a magazine,
      # versions supplied to radio DJs for air-play, etc).
      TYPE_PROMOTION      = NS_MMD_1 + 'Promotion'
      # An unofficial/underground release that was not sanctioned by the artist
      # and/or the record company.
      TYPE_BOOTLEG        = NS_MMD_1 + 'Bootleg'
      # A pseudo-release is a duplicate release for translation/transliteration
      # purposes.
      TYPE_PSEUDO_RELEASE = NS_MMD_1 + 'Pseudo-Release'
      
      # See Entity::ENTITY_TYPE.
      ENTITY_TYPE = :release # :nodoc:
      
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
      # 
      # See:: Utils#get_language_name
      attr_accessor :text_language

      # The script used in release and track titles.
      #
      # To represent the script, ISO-15924 script codes are used.
      # Valid codes are, among others: 'Latn', 'Cyrl', 'Hans', 'Hebr'
      #
      # Note that this refers to release and track <i>titles</i>, not
      # lyrics.
      # 
      # See:: Utils#get_script_name
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
        self.title      = title
        @tracks         = Collection.new
        @release_events = Collection.new
        @discs          = Collection.new
        @types          = Array.new
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
    
      # Returns the earliest release date as an IncompleteDate or +nil+.
      # 
      # See:: earliest_release_date
      def earliest_release_event
        earliest_event = nil
        release_events.each do |event|
          if earliest_event.nil? or (event.date and event.date < earliest_event.date)
            earliest_event = event
          end
        end
        return earliest_event
      end
      
      # Returns the earliest release event or +nil+.
      # 
      # See:: earliest_release_event
      def earliest_release_date
        event = earliest_release_event
        event ? event.date : nil
      end
    
      # Returns the string representation for this release.
      # 
      # Returns #title converted into a string.
      def to_s
        title.to_s
      end
      
    end
    
  end    
end