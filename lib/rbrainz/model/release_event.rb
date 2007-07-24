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
    # See:: http://musicbrainz.org/doc/ReleaseEvent.
    #
    class ReleaseEvent
    
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