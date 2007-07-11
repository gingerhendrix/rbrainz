# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

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