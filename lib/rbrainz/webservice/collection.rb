# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'rbrainz/model/entity'

module MusicBrainz
  module Webservice

    # A Collection is a list of entities.
    # 
    # A Collection is returned as the result of an entity search (e.g. search
    # for an Artist). It contains an ordered list of entities together with a
    # score for each entity, which indicates how good the entity matches the
    # search criteria.
    # 
    # A collection object may only store an extract of the complete data
    # available on the server. This is especially the case if the limit or
    # offset filter was used in the query. The collection object makes the
    # total number of elements on the server and the current offset available
    # with the +count+ respective the +offset+ parameter.
    # 
    # The entities in the collection are sorted by score (in descending order).
    class Collection
    
      # Returns the total number of elements for that collection on the server. 
      attr_reader :count
      
      # Returns the position at which this collection starts. Used for paging
      # through more than one page of results.
      attr_reader :offset
    
      # Create a new collection object.
      # 
      # The count and offset parameters should be set according to the values
      # returned by the server.
      def initialize(count=0, offset=0)
        @entities = Array.new
        @count    = count.to_i
        @offset   = offset.to_i
      end
      
      # Add a new entity to the collection.
      # 
      # Entity can be either a single entity or an Array (or anything else that
      # responds to +first+ and +last+), where entity.first returns the entity
      # itself and entity.last the corresponding score.
      def <<(entity)
        if entity.is_a? Model::Entity
          @entities << [entity, nil]
        else
          @entities << [entity.first, entity.last]
        end
      end
      
      # Returns the number of elements in the collection.
      def size
        return @entities.size
      end
      
      # Iterates over the list of entities with their corresponding score.
      #
      # A block must be given accepting the two parameters |entity, score|.
      def each
        @entities.each {|entity| yield entity}
      end
      
      # Iterate over the entities only without the scores.
      #
      # A block must be given accepting one parameter for the entity.
      def each_entity
        @entities.each  {|entity| yield entity.first}
      end
      
      # Return the entity at the specified index location.
      #
      # Returns a Hash with the two keys :entity and :score.
      def [](index)
        entity = @entities[index]
        return {:entity => entity.first, :score => entity.last}
      end
      
      # Returns true, if the collection contains no entities.
      def empty?
        return size == 0
      end
      
      # Returns an array with all entities without the score.
      def entities
        return @entities.map {|entity| entity.first}
      end

      # Convert the collection into an array.
      #
      # Each element in the array is hash with the two keys :entity and :score.
      def to_a
        return @entities.map {|entity|
          {:entity => entity.first, :score => entity.last}
        }
      end
      
    end
    
  end
end