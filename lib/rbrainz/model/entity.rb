# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.
 
require 'rbrainz/model/mbid'
require 'rbrainz/model/relation'
require 'rbrainz/model/collection'
require 'rbrainz/model/tag'
require 'set'

module MusicBrainz
  module Model

    #
    # A first-level MusicBrainz class.
    # 
    # All entities in MusicBrainz have unique IDs (which are MBID's representing
    # absolute URIs) and may have any number of #relations to other entities.
    # This class is abstract and should not be instantiated.
    # 
    # Relations are differentiated by their <i>target type</i>, that means,
    # where they link to. MusicBrainz currently supports four target types
    # (artists, releases, tracks, and URLs) each identified using a URI.
    # To get all relations with a specific target type, you can use
    # #relations and pass one of the following constants as the
    # parameter:
    #
    # - Relation::TO_ARTIST
    # - Relation::TO_RELEASE
    # - Relation::TO_TRACK
    # - Relation::TO_URL
    #
    # See:: Relation
    #
    class Entity
      
      # The entity type of this entity. Must be set by child classes correctly.
      # 
      # Use #entity_type to query the type.
      ENTITY_TYPE = nil # :nodoc:
      
      # The MusicBrainz ID. A MBID containing an absolute URI.
      attr_reader :id
      
      # A Collection of Tag objects assigned to this entity.
      attr_reader :tags
      
      # Create a new Entity. You can assign a MusicBrainz identifier to the
      # created entity with the parameter _mbid_ (see id=).
      def initialize(mbid=nil)
        self.id = mbid
        @tags = Collection.new
        @relations = {
          Relation::TO_ARTIST  => Collection.new,
          Relation::TO_RELEASE => Collection.new,
          Relation::TO_TRACK   => Collection.new,
          Relation::TO_LABEL   => Collection.new,
          Relation::TO_URL     => Collection.new,
        }
      end
      
      # Set the MBID.
      # 
      # _mbid_ should be an instance of MBID or a string
      # representing either a complete MBID URI or just the
      # UUID part of it. If it is a complete URI the entity
      # part of the URI must match the entity type returned
      # by +entity_type+ or an EntityTypeNotMatchingError
      # will be raised.
      # 
      # Raises: UnknownEntityError, InvalidMBIDError,
      # EntityTypeNotMatchingError
      def id=(mbid)
        if mbid
          @id = MBID.parse(mbid, entity_type)
        else
          @id = nil
        end
      end
      
      # Returns the entity type of the entity class.
      # 
      # Depending on the class this is <tt>:artist</tt>, <tt>:release</tt>,
      # <tt>:track</tt> or <tt>:label</tt>.
      def self.entity_type
        self::ENTITY_TYPE
      end
      
      # Returns the entity type of the instance.
      # 
      # Depending on the class this is <tt>:artist</tt>, <tt>:release</tt>,
      # <tt>:track</tt> or <tt>:label</tt>.
      def entity_type
        self.class.entity_type
      end
      
      #
      # Adds a relation.
      #
      # This method adds _relation_ to the list of relations. The
      # given relation has to be initialized, at least the target
      # type has to be set.
      #
      def add_relation(relation)
        @relations[relation.target_type] << relation
      end
      
      #
      # Returns a list of relations.
      #
      # If _target_type_ is given, only relations of that target
      # type are returned. For MusicBrainz, the following target
      # types are defined:
      # - Relation::TO_ARTIST
      # - Relation::TO_RELEASE
      # - Relation::TO_TRACK
      # - Relation::TO_URL
      # 
      # If _target_type_ is Relation::TO_ARTIST, for example,
      # this method returns all relations between this Entity and
      # artists.
      #
      # You may use the _relation_type_ parameter to further restrict
      # the selection. If it is set, only relations with the given
      # relation type are returned. The _required_attributes_ sequence
      # lists attributes that have to be part of all returned relations.
      #
      # If _direction_ is set, only relations with the given reading
      # direction are returned. You can use the Relation::DIR_FORWARD,
      # Relation::DIR_BACKWARD, and Relation::DIR_BOTH constants
      # for this.
      #
      def get_relations(options = {:target_type => nil, :relation_type => nil,
                                   :required_attributes => [], :direction => nil})
        Utils.check_options options, 
            :target_type, :relation_type, :required_attributes, :direction
        target_type = options[:target_type]
        relation_type = options[:relation_type]
        required_attributes = 
          options[:required_attributes] ? options[:required_attributes] : []
        direction = options[:direction]
        
        # Select all relevant relations depending on the requested target type
        if target_type
          result = @relations[target_type].to_a
        else
          result = @relations.values.flatten
        end
        
        # Filter for direction
        #
        result = result.find_all { |r| r.direction == direction } if direction
        
        # Filter for relation type
        #
        result = result.find_all{ |r| r.type == relation_type } if relation_type
        
        # Filter for attributes
        #
        required = required_attributes.to_set
        result.find_all do |r|
             required.subset?( r.attributes.to_set )
        end
      end
      
      #
      # Returns a list of target types available for this entity.
      # 
      # Use this to find out to which types of targets this entity
      # has relations. If the entity only has relations to tracks and
      # artists, for example, then a list containg the strings
      # Relation::TO_TRACK and Relation::TO_ARTIST is returned.
      #
      def relation_target_types
        result = []
        @relations.each_pair {|type, relations|
          result << type unless relations.empty?
        }
        return result
      end
      
    end
    
  end
end
