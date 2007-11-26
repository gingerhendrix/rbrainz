# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'rbrainz/model/label'

module MusicBrainz
  module Model

    #
    # A release event in the MusicBrainz DB indicating where and when a release
    # took place.
    # 
    # All country codes used must be valid ISO-3166 country codes (i.e. 'DE',
    # 'UK' or 'FR'). The dates are instances of IncompleteDate or strings which
    # must have the format 'YYYY', 'YYYY-MM' or 'YYYY-MM-DD'.
    #
    # The format of the release medium is a URI that can be compared to the
    # constants on this class (FORMAT_CD, FORMAT_DVD and others).
    #
    # See:: http://musicbrainz.org/doc/ReleaseEvent.
    #
    class ReleaseEvent
    
      FORMAT_CD           = NS_MMD_1 + 'CD'
      FORMAT_DVD          = NS_MMD_1 + 'DVD'
      FORMAT_SACD         = NS_MMD_1 + 'SACD'
      FORMAT_DUALDISC     = NS_MMD_1 + 'DualDisc'
      FORMAT_LASERDISC    = NS_MMD_1 + 'LaserDisc'
      FORMAT_MINIDISC     = NS_MMD_1 + 'MiniDisc'
      FORMAT_VINYL        = NS_MMD_1 + 'Vinyl'
      FORMAT_CASSETTE     = NS_MMD_1 + 'Cassette'
      FORMAT_CARTRIDGE    = NS_MMD_1 + 'Cartridge'
      FORMAT_REEL_TO_REEL = NS_MMD_1 + 'ReelToReel'
      FORMAT_DAT          = NS_MMD_1 + 'DAT'
      FORMAT_DIGITAL      = NS_MMD_1 + 'Digital'
      FORMAT_WAX_CYLINDER = NS_MMD_1 + 'WaxCylinder'
      FORMAT_PIANO_ROLL   = NS_MMD_1 + 'PianoRoll'
      FORMAT_OTHER        = NS_MMD_1 + 'Other'
    
      # The country in which an album was released.
      # A string containing a ISO 3166 country code like
      # 'GB', 'US' or 'DE'.
      # 
      # See:: Utils#get_country_name
      # See:: http://musicbrainz.org/doc/ReleaseCountry
      attr_accessor :country
      
      # The catalog number given to the release by the label.
      attr_accessor :catalog_number
      
      # The barcode as it is printed on the release.
      attr_accessor :barcode
      
      # The label issuing the release.
      attr_accessor :label
      
      # The release date. An instance of IncompleteDate.
      attr_reader :date
      
      # The media format of the release (e.g. CD or Vinyl).
      attr_accessor :format
      
      def initialize(country=nil, date=nil)
        self.country = country
        self.date    = date
      end
      
      # Set the date the release took place.
      # 
      # Should be an IncompleteDate object or
      # a date string, which will get converted
      # into an IncompleteDate.
      def date=(date)
        date = IncompleteDate.new date unless date.is_a? IncompleteDate or date.nil?
        @date = date
      end
      
    end
    
  end    
end