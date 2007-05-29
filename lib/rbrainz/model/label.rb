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
    
      TYPE_DISTRIBUTOR         = NS_MMD_1 + 'Distributor'
      TYPE_HOLDING             = NS_MMD_1 + 'Holding'
      TYPE_ORIGINAL_PRODUCTION = NS_MMD_1 + 'OriginalProduction'
      TYPE_BOOTLEG_PRODUCTION  = NS_MMD_1 + 'BootlegProduction'
      TYPE_REISSUE_PRODUCTION  = NS_MMD_1 + 'ReissueProduction'
      
      attr_accessor :name, :sort_name, :disambiguation,
                    :code, :country, :type
      
      attr_reader :founding_date, :dissolving_date, :releases
      
      def initialize
        super
        @releases = Array.new
      end
      
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