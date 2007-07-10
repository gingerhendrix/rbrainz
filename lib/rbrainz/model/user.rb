# $Id: user.rb 78 2007-06-04 19:47:11Z phw $
#
# Author::    Nigel Graham (mailto:nigel_graham@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

module MusicBrainz
  module Model

    # A User.
    # 
    # See http://musicbrainz.org/doc/ArtistAlias.
    class User
      # The MusicBrainz user name.
      attr_accessor :name

      # The user's types.
      # 
      # Most users' type list is empty. Currently, the following types
      # are defined:
      #
      # - 'http://musicbrainz.org/ns/ext-1.0#AutoEditor'
      # - 'http://musicbrainz.org/ns/ext-1.0#RelationshipEditor'
      # - 'http://musicbrainz.org/ns/ext-1.0#Bot'
      # - 'http://musicbrainz.org/ns/ext-1.0#NotNaggable'
      attr_reader :types
      
      def initialize
        @types = []
      end
      
      # The setter for the nag screen flag.
      def show_nag=(value)
        @show_nag = (value.to_s == 'true')
      end
      
      # The value of the nag screen flag.
      def show_nag?
        @show_nag
      end
      
      def to_s
        return name.to_s
      end
    end

  end
end