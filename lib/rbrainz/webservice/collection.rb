# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Philipp Wolfer
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
    # The entities in the collection are sorted by score (in descending order).
    class Collection
    
      def initialize
        @entities = Array.new
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

    end
    
  end
end