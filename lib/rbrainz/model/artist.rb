# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'rbrainz/model/individual'
require 'rbrainz/model/alias'

module MusicBrainz
  module Model

    # An artist in the MusicBrainz DB.
    # 
    # See http://musicbrainz.org/doc/Artist.
    class Artist < Individual
    
      TYPE_PERSON = NS_MMD_1 + 'Person'
      TYPE_GROUP  = NS_MMD_1 + 'Group'
      
      attr_reader :aliases, :releases
                    
      def initialize
        super
        @aliases = Array.new
        @releases = Array.new
      end
      
    end

  end
end