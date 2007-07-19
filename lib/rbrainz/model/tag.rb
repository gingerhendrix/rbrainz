# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

module MusicBrainz
  module Model

    #
    # Represents a tag assigned to an entity.
    # 
    # Tags are arbitrary labels assigned to entities by the users of MusicBrainz.
    # 
    # Note:: Tagging is not supported by the current MusicBrainz server but will
    #        be added in the near future.
    class Tag
      # The tag text.
      attr_accessor :text

      # The tag count indicating how often the tag was used for the entity it's
      # assigned to.
      attr_accessor :count
      
      def initialize(text=nil, count=nil)
        self.text  = text
        self.count = count
      end
      
      # Convert this tag into a String. Will return text.
      def to_s
        return text.to_s
      end
      
    end

  end
end