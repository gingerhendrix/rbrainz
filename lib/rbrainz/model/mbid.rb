# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

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
      
      # Creates a new MBID from either a MBID URI or the UUID.
      # 
      # In case a complete URI is given its entity type must match the
      # given entity type or an +EntityTypeNotMatchingError+ will be thrown.
      def self.from_string(entity_type, string)
        # Try to create an MBID from URI
        begin
          id = MBID.from_uri(string)
          # Check if the entity type of @id matches that of the current object.
          unless entity_type == id.entity
            raise EntityTypeNotMatchingError.new(id.to_s)
          end
        rescue InvalidMBIDError => e
          # Try it again and use mbid as the UUID
          id = MBID.from_uuid(entity_type, string)
        end
        return id
      end
      
      # Creates a new MBID from a MBID URI, e.g.
      # http://musicbrainz.org/artist/6a2ca1ac-408d-49b0-a7f6-cd608f2f684f
      def self.from_uri(uri)
        if match = ENTITY_URI_REGEXP.match(uri)
          entity_type = match[1]
          uuid = match[2]
        else
          raise InvalidMBIDError.new(uri.inspect)
        end
        from_uuid(entity_type, uuid)
      end
      
      # Create a new MBID from the entity type and the UUID.
      # 
      # The entity type must be <tt>:artist</tt>, <tt>:release</tt>,
      # <tt>:track</tt> or <tt>:label</tt>. The UUID is the last
      # part of the URI, e.g. <tt>6a2ca1ac-408d-49b0-a7f6-cd608f2f684f</tt>.
      # 
      # Raises: +UnknownEntityError+, +InvalidUUIDError+
      def self.from_uuid(entity_type, uuid)
        if entity_type.nil? or entity_type == '' or
           not [:artist, :release, :track, :label].include? entity_type.to_sym
          raise UnknownEntityError.new(entity_type.to_s)
        end
        unless uuid.is_a? String and uuid =~ UUID_REGEXP
          raise InvalidUUIDError.new(uuid.inspect)
        end
        new(entity_type.to_sym, uuid)
      end
      
      # Initialize the UUID given the entity type and an UUID.
      def initialize(entity_type, uuid) # :notnew:
        @entity = entity_type
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