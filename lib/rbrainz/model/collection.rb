# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'rbrainz/model/entity'

module MusicBrainz
  module Model

    # A Collection is a list of models.
    # 
    # A collection object may only store an extract of the complete data
    # available on the server. This is especially the case if the limit or
    # offset filter was used in the query. The collection object makes the
    # total number of elements on the server and the current offset available
    # with the +count+ respective the +offset+ parameter.
    class Collection
    
      include ::Enumerable
      
      # Returns the total number of elements for that collection on the server. 
      attr_accessor :count
      
      # Returns the position at which this collection starts. Used for paging
      # through more than one page of results.
      attr_accessor :offset
    
      # Create a new collection object.
      # 
      # The count and offset parameters should be set according to the values
      # returned by the server.
      def initialize(count=0, offset=0, array=nil)
        @count  = count.to_i
        @offset = offset.to_i
        if array
          @entries = array.to_ary.dup
        else
          @entries = Array.new
        end
      end
      
      # Add a new element to this collection.
      def <<(entry)
        @entries << entry
      end
      
      # Delete an element from the collection.
      def delete(entry)
        @entries.delete(entry)
      end
      
      # Iterate over the contents of the collection.
      def each
        @entries.each {|e| yield e}
      end
      
      # Access a random element in the collection by the element's index.
      def [](index)
        @entries[index]
      end
      
      # Set a random element in the collection by the element's index.
      def []=(index, entry)
        @entries[index] = entry
      end
      
      # Create a new collection containing the elements of both collections.
      # Count and offset will be set to +nil+ in the new collection.
      def +(other_collection)
        new_collection = Collection.new
        (self.to_a + other_collection.to_a).each do |entry|
          new_collection << entry
        end
        return new_collection
      end
      
      # The number of elements in the collection.
      def size
        @entries.size
      end
      
      # Returns true, if the collection contains no elements.
      def empty?
        @entries.empty?
      end
      
      # Convert the collection into an Array.
      def to_a
        @entries.dup
      end
      alias to_ary to_a
      
      def dup
        Collection.new(self.count, self.offset, @entries)
      end
    end
    
  end
end