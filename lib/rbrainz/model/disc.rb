# $Id$
# Copyright (c) 2007, Philipp Wolfer
# All rights reserved.
# See LICENSE for permissions.

module MusicBrainz
  module Model

    # Represents an audio CD.
    # 
    # A disc has a disc id, which is calculated from the
    # CD's table of contents (TOC). It also can include
    # the numbers of sectors on the CD.
    # 
    # The disc id is mainly used to lookup a release in
    # the MusicBrainz database the matches a given disc
    # id. See Webservice::ReleaseFilter for details on
    # this.
    # 
    # If you need to calculate disc IDs you should install the mb-discid
    # package. It allows you to calculate the disc ID for an audio CD.
    # 
    # Example:
    #  require 'rbrainz'
    #  require 'mb-discid'
    #  
    #  discid = MusicBrainz::DiscID.new
    #  discid.read
    #  
    #  disc = MusicBrainz::Model::Disc.new
    #  disc.id = discid
    # 
    # See http://wiki.musicbrainz.org/DiscID for more information about
    # MusicBrainz disc IDs.
    class Disc
    
      attr_accessor :sectors
      attr_reader :id
      
      # Set the MusicBrainz disc ID for this disc.
      # 
      # The disc_id argument can be a string or a MusicBrainz::DiscID object.
      def id=(disc_id)
        @id = disc_id.to_s
      end
      
    end

  end
end