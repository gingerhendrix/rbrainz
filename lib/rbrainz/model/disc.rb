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
    # See http://wiki.musicbrainz.org/DiscID.
    # 
    # TODO: Currently the calculation of a disc ID is not supported.
    class Disc
    
      attr_accessor :id, :sectors
      
    end

  end
end