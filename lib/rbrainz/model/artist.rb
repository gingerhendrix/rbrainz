# $Id$
# Copyright (c) 2007, Philipp Wolfer
# All rights reserved.
# See LICENSE for permissions.

require 'rbrainz/model/entity'
require 'rbrainz/model/alias'
require 'rbrainz/model/incomplete_date'

module MusicBrainz
  module Model

    # An artist in the MusicBrainz DB.
    # 
    # See http://musicbrainz.org/doc/Artist.
    class Artist < Entity
    
      TYPE_PERSON = NS_MMD_1 + 'Person'
      TYPE_GROUP  = NS_MMD_1 + 'Group'
      
      attr_accessor :name, :sort_name, :disambiguation,
                    :type, :aliases, :releases
                    
      attr_reader :begin_date, :end_date
                    
      def initialize
        super
        @aliases = Array.new
        @releases = Array.new
      end
      
      # Set the begin date of this artist.
      # 
      # Should be an IncompleteDate object or
      # a date string, which will get converted
      # into an IncompleteDate.
      def begin_date=(date)
        date = IncompleteDate.new date unless date.is_a? IncompleteDate
        @begin_date = date
      end
      
      # Set the end date of this artist.
      # 
      # Should be an IncompleteDate object or
      # a date string, which will get converted
      # into an IncompleteDate.
      def end_date=(date)
        date = IncompleteDate.new date unless date.is_a? IncompleteDate
        @end_date = date
      end
      
    end

  end
end