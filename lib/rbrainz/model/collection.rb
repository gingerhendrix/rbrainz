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
    class Collection < ::Array
    
      # Returns the total number of elements for that collection on the server. 
      attr_accessor :count
      
      # Returns the position at which this collection starts. Used for paging
      # through more than one page of results.
      attr_accessor :offset
    
      # Create a new collection object.
      # 
      # The count and offset parameters should be set according to the values
      # returned by the server.
      def initialize(count=0, offset=0)
        @count  = count.to_i
        @offset = offset.to_i
      end
      
    end
    
  end
end