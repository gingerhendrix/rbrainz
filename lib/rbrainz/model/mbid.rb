# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'uri'

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
    # Example:
    #  http://musicbrainz.org/artist/6a2ca1ac-408d-49b0-a7f6-cd608f2f684f
    # 
    # See:: http://musicbrainz.org/doc/MusicBrainzIdentifier
    class MBID
    
      # The entity type (<tt>:artist</tt>, <tt>:label</tt>, <tt>:release</tt>,
      # <tt>:track</tt>) this MBID references.
      attr_reader :entity
      
      # The UUID of the referenced entity.
      attr_reader :uuid
      
      module PATTERN #:nodoc:
        UUID = '([a-fA-F0-9]{8}(:?-[a-fA-F0-9]{4}){3}-[a-fA-F0-9]{12})'
        ENTITY_TYPE = '(artist|release|track|label)'
        ENTITY_URI = "http://musicbrainz\\.org/#{ENTITY_TYPE}/#{UUID}"
      end
      
      # A regular expression describing the format of a UUID.
      UUID_REGEXP = Regexp.new('^' + PATTERN::UUID + '$')
      # A regular expression to test if a string is a valid entity type.
      ENTITY_TYPE_REGEXP = Regexp.new('^' + PATTERN::ENTITY_TYPE + '$')
      # A regular expression describing a MusicBrainz identifier URI.
      ENTITY_URI_REGEXP = Regexp.new('^' + PATTERN::ENTITY_URI + '$')
      
      # The general format of a MusicBrainz identifier URI.
      ENTITY_URI = 'http://musicbrainz.org/%s/%s'
      
      # Tries to convert _str_ into a MBID using its to_mbid method.
      # 
      # If _str_ does not respond to to_mbid a new MBID is created
      # using the given parameters.
      # 
      # See:: new
      # See:: String#to_mbid, URI::HTTP#to_mbid
      def self.parse(str, entity_type=nil)
        if str.respond_to? :to_mbid
          str.to_mbid(entity_type)
        else
          MBID.new(str, entity_type)
        end
      end
      
      # Create a new MBID.
      # 
      # _str_ can be either a complete identifier or just the UUID part of it.
      # In the latter case the entity type (<tt>:artist</tt>, <tt>:label</tt>,
      # <tt>:release</tt> or <tt>:track</tt>) has to be specified as well.
      # 
      # Examples:
      #  require 'rbrainz'
      #  include MusicBrainz
      #  id = Model::MBID.new('http://musicbrainz.org/artist/10bf95b6-30e3-44f1-817f-45762cdc0de0')
      #  id = Model::MBID.new('10bf95b6-30e3-44f1-817f-45762cdc0de0', :artist)
      #  
      # Raises:: UnknownEntityError, EntityTypeNotMatchingError,
      #          InvalidMBIDError
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
      
      # Returns self.
      # 
      # If _entity_type_ is given it must match the entity type of the MBID
      # or an EntityTypeNotMatchingError will be raised.
      # 
      # Raises:: EntityTypeNotMatchingError
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
