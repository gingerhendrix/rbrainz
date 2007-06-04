# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'rbrainz/model/label'

module MusicBrainz
  module Model

    # A release event in the MusicBrainz DB.
    # 
    # See http://musicbrainz.org/doc/ReleaseEvent.
    class ReleaseEvent
    
      attr_accessor :country, :catalog_number,
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