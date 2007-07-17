# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'rbrainz/model/entity'

module MusicBrainz
  module Model

    # A track in the MusicBrainz DB.
    # 
    # See:: http://musicbrainz.org/doc/Track.
    class Track < Entity
    
      # See Entity::ENTITY_TYPE.
      ENTITY_TYPE = :track # :nodoc:
      
      # The track's title.
      attr_accessor :title
      
      # The duration in milliseconds.
      attr_accessor :duration
      
      # The track's main artist.
      attr_accessor :artist
      
      # The list of associated PUIDs.           
      attr_reader :puids
      
      # The releases on which this track appears.
      attr_reader :releases
      
      def initialize(id=nil, title=nil)
        super id
        @title    = title
        @puids    = Collection.new
        @releases = Collection.new
      end
      
      # Returns the string representation for this track.
      # 
      # Returns #title converted into a string.
      def to_s
        title.to_s
      end
      
    end

  end
end