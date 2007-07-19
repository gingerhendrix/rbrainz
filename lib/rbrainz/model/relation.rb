# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.
 
module MusicBrainz
  module Model

    ##
    # Represents a relation between two Entities.
    #
    # There may be an arbitrary number of relations between all first
    # class objects in MusicBrainz. The Relation itself has multiple
    # attributes, which may or may not be used for a given relation
    # type.
    #
    # Note that a Relation object only contains the target but not
    # the source end of the relation.
    #
    # TODO:: Add some examples.
    #
    class Relation
    
      # Relation reading direction is from target to source.
      DIR_BACKWARD = :backward
      # Relation reading direction is from source to target.
      DIR_FORWARD  = :forward
      # Relation reading direction doesn't matter.
      DIR_BOTH     = :both
      
      # Identifies relations linking to an artist.
      TO_ARTIST  = NS_REL_1 + 'Artist'
      # Identifies relations linking to a release.
      TO_RELEASE = NS_REL_1 + 'Release'
      # Identifies relations linking to a track.
      TO_TRACK   = NS_REL_1 + 'Track'
      # Identifies relations linking to a label.
      TO_LABEL   = NS_REL_1 + 'Label'
      # Identifies relations linking to an URL.
      TO_URL     = NS_REL_1 + 'Url'
      
      # The relation's type.
      attr_accessor :type
      
      # The reading direction.
      #
      # The direction may be one of DIR_FORWARD, DIR_BACKWARD, or DIR_BOTH,
      # depending on how the relation should be read. For example,
      # if direction is DIR_FORWARD for a cover relation,
      # it is read as "X is a cover of Y". Some relations are
      # bidirectional, like marriages. In these cases, the direction
      # is Relation.DIR_BOTH.
      attr_accessor :direction
      
      # The relation's target object.
      attr_reader :target
      
      # The list of attributes describing this relation.
      #
      # The attributes permitted depend on the relation type.
      attr_reader :attributes
      
      # The begin date.
      #
      # The definition depends on the relation's type. It may for
      # example be the day of a marriage or the year an artist
      # joined a band. For other relation types this may be
      # undefined.
      attr_reader :begin_date
      
      # The end date.
      #
      # As with the begin date, the definition depends on the
      # relation's type. Depending on the relation type, this may
      # or may not be defined.
      attr_reader :end_date
      
      def initialize(type=nil, target=nil, direction=nil)
        @target        = nil
        @attributes    = Array.new
        self.type      = type
        self.target    = target if target
        self.direction = direction
      end
      
      # Set the target of this relation.
      # 
      # The _target_ can either be a object of the type Model::Entity
      # or a URL.
      def target=(target)
        if target.is_a? Entity
          @target = target
        else
          @target = target.to_s
        end
      end
      
      # The type of target this relation points to.
      #
      # For MusicBrainz data, the following target types are defined:
      # - artists: #TO_ARTIST
      # - labels: #TO_LABEL
      # - releases: #TO_RELEASE
      # - tracks: #TO_TRACK
      # - urls: #TO_URL
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
      
      # Set the begin date of this relation to _date_.
      # 
      # Should be an IncompleteDate object or
      # a date string, which will get converted
      # into an IncompleteDate.
      def begin_date=(date)
        date = IncompleteDate.new date unless date.is_a? IncompleteDate
        @begin_date = date
      end
      
      # Set the end date of this relation to _date_.
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
