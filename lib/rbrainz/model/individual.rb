# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'rbrainz/model/entity'
require 'rbrainz/model/incomplete_date'

module MusicBrainz
  module Model

    # Superclass for Artist and Label.
    # 
    # Aggregates the common attributes of artists and labels.
    class Individual < Entity
    
      attr_accessor :name, :sort_name, :disambiguation, :type
                    
      attr_reader :aliases, :begin_date, :end_date
      
      # The list of releases of this artist or label.
      #
      # This may also include releases where this artist isn't the
      # <i>main</i> artist but has just contributed one or more tracks
      # (aka VA-Releases).
      attr_reader :releases
    
      def initialize(id=nil, type=nil, name=nil, sort_name=nil)
        super id
        @type      = type
        @name      = name
        @sort_name = sort_name
        @aliases   = Collection.new
        @releases  = Collection.new
      end
                    
      # Set the begin date of this individual.
      # 
      # Should be an IncompleteDate object or
      # a date string, which will get converted
      # into an IncompleteDate.
      def begin_date=(date)
        date = IncompleteDate.new date unless date.is_a? IncompleteDate
        @begin_date = date
      end
      
      # Set the end date of this individual.
      # 
      # Should be an IncompleteDate object or
      # a date string, which will get converted
      # into an IncompleteDate.
      def end_date=(date)
        date = IncompleteDate.new date unless date.is_a? IncompleteDate
        @end_date = date
      end
      
      # Returns a unique name for the individual (using disambiguation).
      #
      # The unique name ist the individual's name together with the
      # disambiguation attribute in parenthesis if it exists. 
      #
      # Example: 'Paradise Lost  (British metal / hard rock band)'.
      def unique_name
        unique_name = @name
        unique_name += ' (%s)' % @disambiguation if @disambiguation
        return unique_name
      end
      
    end

  end
end