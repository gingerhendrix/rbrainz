# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'rbrainz/model/entity'

module MusicBrainz
  module Model

    # A track in the MusicBrainz DB.
    # 
    # See http://musicbrainz.org/doc/Track.
    class Track < Entity
    
      attr_accessor :title, :duration, :artist
                    
      attr_reader :puids, :releases
      
      def initialize(id=nil, title=nil)
        super id
        @title    = title
        @puids    = Collection.new
        @releases = Collection.new
      end
      
    end

  end
end