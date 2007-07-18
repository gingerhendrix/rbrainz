# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'rbrainz/model/artist'
require 'rbrainz/model/label'
require 'rbrainz/model/release'
require 'rbrainz/model/track'
require 'rbrainz/model/user'

module MusicBrainz
  module Model

    # A factory to create model classes.
    class DefaultFactory
      
      # Creates a new entity for a given entity type (<tt>:artist</tt>,
      # <tt>:label</tt>, <tt>:release</tt> or <tt>:track</tt>).
      def new_entity(entity_type)
        case entity_type
          when :artist
            new_artist
          when :label
            new_label
          when :release
            new_release
          when :track
            new_track
        end
      end
      
      def new_artist
        Artist.new
      end
      
      def new_label
        Label.new
      end
      
      def new_release
        Release.new
      end
      
      def new_track
        Track.new
      end
      
      def new_alias
        Alias.new
      end
      
      def new_disc
        Disc.new
      end
      
      def new_relation
        Relation.new
      end
      
      def new_release_event
        ReleaseEvent.new
      end
      
      def new_tag
        Tag.new
      end
      
      def new_user
        User.new
      end
      
    end
    
  end
end