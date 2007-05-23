# $Id$
# Copyright (c) 2007, Philipp Wolfer
# All rights reserved.
# See LICENSE for permissions.

require 'rbrainz/model'

module MusicBrainz
  module Model

    # Represents a MusicBrainz identifier.
    # 
    # A MusicBrainz identifier is an URI identifying a resource like an artist or a track.
    # It consists of an URI prefix, the entity type it refers to and an UUID that
    # identifies the referenced entity. 
    # 
    # See http://musicbrainz.org/doc/MusicBrainzIdentifier.
    # 
    # Example: http://musicbrainz.org/artist/6a2ca1ac-408d-49b0-a7f6-cd608f2f684f.
    class MBID
    
      attr_reader :entity, :uuid
      
      ENTITY_URI = 'http://musicbrainz.org/%s/%s'
      ENTITY_URI_REGEXP = /^http:\/\/musicbrainz.org\/(artist|release|track|label)\/([a-f0-9]{8}(-[a-f0-9]{4}){3}-[a-f0-9]{12})\/?$/
      
      # We make new private. Use from_uri or from_uuid instead.
      private_class_method :new
      
      # Creates a new MBID from a MBID URI, e.g.
      # http://musicbrainz.org/artist/6a2ca1ac-408d-49b0-a7f6-cd608f2f684f
      def self.from_uri(uri)
        if match = ENTITY_URI_REGEXP.match(uri)
          entity = match[1]
          uuid = match[2]
        else
          raise InvalidMBIDError.new(uri.inspect)
        end
        from_uuid(entity, uuid)
      end
      
      # Create a new MBID from the entity type and the UUID.
      # 
      # The entity type must be <tt>:artist</tt>, <tt>:release</tt>,
      # <tt>:track</tt> or <tt>:label</tt>. The UUID is the last
      # part of the URI, e.g. <tt>6a2ca1ac-408d-49b0-a7f6-cd608f2f684f</tt>.
      # 
      # Raises: +UnknownEntityError+, +InvalidUUIDError+
      def self.from_uuid(entity, uuid)
        if entity.nil? or entity == '' or
           not [:artist, :release, :track, :label].include? entity.to_sym
          raise UnknownEntityError.new(entity.to_s)
        end
        unless uuid.is_a? String and uuid =~ UUID_REGEXP
          raise InvalidUUIDError.new(uuid.inspect)
        end
        new(entity.to_sym, uuid)
      end
      
      # Initialize the UUID given the entity type and an UUID.
      def initialize(entity, uuid) # :notnew:
        @entity = entity
        @uuid = uuid
      end
      
      # Returns the string representation of the MBID (that is the complete URI).
      def to_s
        ENTITY_URI % [entity.to_s, uuid]
      end
      
      # Compares this MBID with another one.
      # 
      # Two MBIDs are considered equal if both their entity
      # type and their UUID are equal.
      def ==(other)
        self.entity == other.entity and self.uuid == other.uuid
      end
      
    end

  end
end