# $Id$
# Copyright (c) 2007, Philipp Wolfer
# All rights reserved.
# See LICENSE for permissions.

module MusicBrainz
  module Model

    # An artist alias.
    # 
    # See http://musicbrainz.org/doc/ArtistAlias.
    class Alias
    
      attr_accessor :name, :type, :script
      
      def to_s
        return name.to_s
      end
      
    end

  end
end