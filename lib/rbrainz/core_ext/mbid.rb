# $Id$
#
# Core extensions to add a to_mbid conversion to existing classes.
# 
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

#
class String
  # Convert a string into a MusicBrainz::Model::MBID object of the given type.
  # 
  # Raises:: MusicBrainz::Model::EntityTypeNotMatchingError
  def to_mbid(entity_type=nil)
    ::MusicBrainz::Model::MBID.new(self, entity_type)
  end
end

#
module URI #:nodoc:
  class HTTP
    # Create a MusicBrainz::Model::MBID from a HTTP object of the given type.
    # 
    # Raises:: MusicBrainz::Model::EntityTypeNotMatchingError
    def to_mbid(entity_type=nil)
      ::MusicBrainz::Model::MBID.new(self.to_s, entity_type)
    end
  end
end
