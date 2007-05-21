# $Id$
# Copyright (c) 2007, Philipp Wolfer
# All rights reserved.
# See LICENSE for permissions.

require 'rbrainz/model/entity'
require 'rbrainz/model/incomplete_date'

module MusicBrainz
  module Model

    # A label in the MusicBrainz DB.
    # 
    # See http://musicbrainz.org/doc/Label.
    class Label < Entity
    
      TYPE_DISTRIBUTOR         = 'http://musicbrainz.org/ns/mmd-1.0#Distributor'
      TYPE_HOLDING             = 'http://musicbrainz.org/ns/mmd-1.0#Holding'
      TYPE_ORIGINAL_PRODUCTION = 'http://musicbrainz.org/ns/mmd-1.0#OriginalProduction'
      TYPE_BOOTLEG_PRODUCTION  = 'http://musicbrainz.org/ns/mmd-1.0#BootlegProduction'
      TYPE_REISSUE_PRODUCTION  = 'http://musicbrainz.org/ns/mmd-1.0#ReissueProduction'
      
      attr_accessor :name, :sort_name, :disambiguation,
                    :code, :country, :type, :releases
      
      attr_reader :founding_date, :dissolving_date
      
      # Set the founding date of the label.
      # 
      # Should be an IncompleteDate object or
      # a date string, which will get converted
      # into an IncompleteDate.
      def founding_date=(date)
        date = IncompleteDate.new date unless date.is_a? IncompleteDate
        @founding_date = date
      end
      
      # Set the dissolving date of the label.
      # 
      # Should be an IncompleteDate object or
      # a date string, which will get converted
      # into an IncompleteDate.
      def dissolving_date=(date)
        date = IncompleteDate.new date unless date.is_a? IncompleteDate
        @dissolving_date = date
      end
      
    end
    
  end
end