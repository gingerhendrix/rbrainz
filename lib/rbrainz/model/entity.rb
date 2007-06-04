# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.
 
require 'rbrainz/model/mbid'
require 'rbrainz/model/relation'

module MusicBrainz
  module Model

    # Superclass for all entities.
    class Entity
    
      attr_reader :id
      
      def initialize
        @relations = {
          Relation::TO_ARTIST  => Array.new,
          Relation::TO_RELEASE => Array.new,
          Relation::TO_TRACK   => Array.new,
          Relation::TO_LABEL   => Array.new,
          Relation::TO_URL     => Array.new,
        }
      end
      
      # Set the MBID.
      # 
      # +mbid+ should be an instance of +MBID+ or a string
      # representing either a complete MBID URI or just the
      # UUID part of it. If it is a complete URI the entity
      # part of the URI must match the entity type returned
      # by +entity_type+ or an +EntityTypeNotMatchingError+
      # will be raised.
      # 
      # Raises: +UnknownEntityError+, +InvalidUUIDError+,
      # +EntityTypeNotMatchingError+
      def id=(mbid)
        # If this already is an instance of MBID store it directly.
        if mbid.is_a? MBID
          @id = mbid
          # Check if the entity type of @id matches that of the current object.
          unless @id.entity == self.entity_type
            exception = EntityTypeNotMatchingError.new(@id.entity.to_s)
            @id = nil
            raise exception
          end
        elsif mbid.nil?
          @id = nil
        else
          @id = MBID.from_string(self.entity_type, mbid)
        end
      end
      
      # Returns the entity type of the entity class.
      # 
      # Depending on the class this is <tt>:artist</tt>, <tt>:release</tt>,
      # <tt>:track</tt> or <tt>:label</tt>.
      def self.entity_type
        self.name.sub('MusicBrainz::Model::', '').downcase.to_sym
      end
      
      # Returns the entity type of the instance.
      # 
      # Depending on the class this is <tt>:artist</tt>, <tt>:release</tt>,
      # <tt>:track</tt> or <tt>:label</tt>.
      def entity_type
        self.class.entity_type
      end
      
      # Add a relation to this entity.
      def add_relation(relation)
        @relations[relation.target_type] << relation
      end
      
      # Returns the relations of this entity.
      def get_relations(options = {:target_type => nil, :relation_type => nil,
                                   :required_attributes => [], :direction => nil})
        # Select all results depending on the requested target type
        if options[:target_type]
          result = @relations[options[:target_type]]
        else
          result = []
          @relations.each_value {|array| result += array}
        end
        
        # Remove relations which don't meet all the criteria.
        result.delete_if {|relation|
          (options[:relation_type] and relation.type != options[:relation_type]) \
          or (options[:required_attributes] and
              (relation.attributes & options[:required_attributes]).sort \
               != options[:required_attributes].sort) \
          or (options[:direction] and relation.direction != options[:direction])
        }
        
        return result
      end
      
      # Return all relation target types for which this entity
      # has relations defined.
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
