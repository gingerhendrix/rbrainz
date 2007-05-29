# $Id$
# Copyright (c) 2007, Philipp Wolfer
# All rights reserved.
# See LICENSE for permissions.
 
module MusicBrainz
  module Model

    # Relationship class.
    class Relation
    
      DIR_BACKWARD = :backward
      DIR_FORWARD  = :forward
      DIR_BOTH     = :both
      
      TO_ARTIST  = 'http://musicbrainz.org/ns/rel-1.0#Artist'
      TO_RELEASE = 'http://musicbrainz.org/ns/rel-1.0#Release'
      TO_TRACK   = 'http://musicbrainz.org/ns/rel-1.0#Track'
      TO_LABEL   = 'http://musicbrainz.org/ns/rel-1.0#Label'
      TO_URL     = 'http://musicbrainz.org/ns/rel-1.0#Url'
      
      attr_accessor :type, :direction
      
      attr_reader :target, :begin_date, :end_date, :attributes
      
      def initialize
        @attributes = Array.new
        @target = nil
      end
      
      # Set the target of this relation.
      # 
      # The target can either be a object of the type Model::Entity
      # or a URL.
      def target=(target)
        if target.is_a? Entity
          @target = target
        else
          @target = target.to_s
        end
      end
      
      # Get the target type.
      def target_type
        if @target.is_a? Model::Entity
          case @target.entity_type
          when :artist
            return TO_ARTIST
          when :release
            return TO_RELEASE
          when :track
            return TO_TRACK
          when :label
            return TO_LABEL
          end
        elsif not @target.nil?
          return TO_URL
        end  
      end
      
      # Set the begin date of this relation.
      # 
      # Should be an IncompleteDate object or
      # a date string, which will get converted
      # into an IncompleteDate.
      def begin_date=(date)
        date = IncompleteDate.new date unless date.is_a? IncompleteDate
        @begin_date = date
      end
      
      # Set the end date of this relation.
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
