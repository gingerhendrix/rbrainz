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
    #  took place.
    # 
    # All country codes used must be valid ISO-3166 country codes (i.e. 'DE',
    # 'UK' or 'FR'). The dates are strings and must have the format 'YYYY',
    # 'YYYY-MM' or 'YYYY-MM-DD'.
    #
    # == See
    # http://musicbrainz.org/doc/ReleaseEvent.
    #
    class ReleaseEvent
    
      attr_accessor :country
      attr_accessor :catalog_number,
                    :barcode, :label
                    
      attr_reader :date
      
      # Set the date the release took place.
      # 
      # Should be an IncompleteDate object or
      # a date string, which will get converted
      # into an IncompleteDate.
      def date=(date)
        date = IncompleteDate.new date unless date.is_a? IncompleteDate
        @date = date
      end
      
    end
    
  end    
end