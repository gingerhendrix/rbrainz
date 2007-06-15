# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'uri'

class String
  def to_mbid(entity_type=nil)
    ::MusicBrainz::Model::MBID.new(self, entity_type)
  end
end

module URI
  class HTTP
    def to_mbid(entity_type=nil)
      ::MusicBrainz::Model::MBID.new(self.to_s, entity_type)
    end
  end
end

module MusicBrainz
  module Model

    # The format of a MusicBrainz identifier was wrong.
    class InvalidMBIDError < Exception
    end
    
    # An unknown entity was encountered.
    # Valid entities are only :artist, :release, :track and :label.
    class UnknownEntityError < Exception
    end
    
    # The entity type of a MBID didn't match the type of the entity.
    class EntityTypeNotMatchingError < Exception
    end

    # Represents a MusicBrainz identifier.
    # 
    # A MusicBrainz identifier is an URI identifying a resource like an artist
    # or a track.
    # It consists of an URI prefix, the entity type it refers to and an UUID 
    # that identifies the referenced entity. 
    # 
    # See http://musicbrainz.org/doc/MusicBrainzIdentifier.
    # 
    # Example: http://musicbrainz.org/artist/6a2ca1ac-408d-49b0-a7f6-cd608f2f684f.
    class MBID
    
      attr_reader :entity, :uuid
      
      module PATTERN
        # :stopdoc:
        
        UUID = '([a-fA-F0-9]{8}(:?-[a-fA-F0-9]{4}){3}-[a-fA-F0-9]{12})'
        ENTITY_TYPE = '(artist|release|track|label)'
        ENTITY_URI = "http://musicbrainz\\.org/#{ENTITY_TYPE}/#{UUID}"
        # :startdoc:
      end
      
      UUID_REGEXP = Regexp.new('^' + PATTERN::UUID + '$')
      ENTITY_TYPE_REGEXP = Regexp.new('^' + PATTERN::ENTITY_TYPE + '$')
      ENTITY_URI_REGEXP = Regexp.new('^' + PATTERN::ENTITY_URI + '$')
      
      ENTITY_URI = 'http://musicbrainz.org/%s/%s'
      
      class << self
        def parse(str, entity_type=nil)
          if str.respond_to? :to_mbid
            str.to_mbid(entity_type)
          else
            MBID.new(str, entity_type)
          end
        end
      end

      def initialize(str, entity_type=nil)
        str = str.to_s if str.respond_to? :to_s
        if entity_type && !(entity_type.to_s =~ ENTITY_TYPE_REGEXP )
          raise UnknownEntityError, entity_type
        end
        entity_type = entity_type.to_sym if entity_type.respond_to? :to_sym
        
        if str =~ ENTITY_URI_REGEXP
          @entity = $1.to_sym
          @uuid = $2.downcase
          unless entity_type.nil? || @entity == entity_type
            raise EntityTypeNotMatchingError, "#{@entity}, #{entity_type}"
          end
        elsif str =~ UUID_REGEXP
          unless entity_type
            raise UnknownEntityError, "nil is not a valid entity type"
          end
          @entity = entity_type
          @uuid = str.downcase
        else
          raise InvalidMBIDError, str
        end
      end
      
      def to_mbid(entity_type=nil)
        unless entity_type.nil? || @entity == entity_type
          raise EntityTypeNotMatchingError, "#{self.entity}, #{entity_type}"
        end
        self
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
        other = other.to_mbid if other.respond_to? :to_mbid
        self.entity == other.entity and self.uuid == other.uuid
      end
      
    end

  end
end
