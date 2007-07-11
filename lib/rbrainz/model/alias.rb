# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

module MusicBrainz
  module Model

    #
    # Represents an artist alias.
    #
    # An alias (the <i>alias name</i>) is a different representation of an
    # artist's name. This may be a common misspelling or a transliteration
    # (the <i>alias type</i>).
    # 
    # The <i>alias script</i> is interesting mostly for transliterations and
    # indicates which script is used for the alias value. To represent the
    # script, ISO-15924 script codes like 'Latn', 'Cyrl', or 'Hebr' are used.
    #
    # An artist alias.
    # 
    # == See
    # http://musicbrainz.org/doc/ArtistAlias.
    class Alias
      # The alias name.
      attr_accessor :name

      # The alias type.
      attr_accessor :type

      # The alias script.
      attr_accessor :script
      
      def to_s
        return name.to_s
      end
      
    end

  end
end