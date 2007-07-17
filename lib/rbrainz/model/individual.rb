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
    
      # The name of the artist or label.
      attr_accessor :name
      
      # Name used for sorting (e.g. "White Stripes, The").
      attr_accessor :sort_name
      
      # Field to distinguish between identically named artists or labels.
      attr_accessor :disambiguation
      
      # The type of this artist or label. See the constants defined in Artist
      # and Label for a list of possible types.
      attr_accessor :type
      
      # Collection of alternate names, including possible typos.
      attr_reader :aliases
      
      # The begin date is interpreted differently for bands, individual artists
      # and labels. For bands and labels this is the founding date, for
      # individual artists it is the date of birth.
      # The begin date is an instance of IncompleteDate.
      attr_reader :begin_date
      
      # The end date is interpreted differently for bands, individual artists
      # and labels. For bands and labels this is the breakup date, for
      # individual artists it is the date of death.
      # The begin date is an instance of IncompleteDate.
      attr_reader :end_date
      
      # A Collection of releases of this artist or label.
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
        @disambiguation = nil
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
      # Example:: 'Paradise Lost  (British metal / hard rock band)'.
      def unique_name
        unique_name = @name
        unique_name += " (#{@disambiguation})" if @disambiguation
        return unique_name
      end
      
      # Returns the string representation for this individual.
      # 
      # Returns #unique_name converted into a string.
      def to_s
        unique_name.to_s
      end
      
    end

  end
end