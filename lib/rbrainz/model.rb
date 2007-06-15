# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

module MusicBrainz
  module Model

    # Namespace for all MusicBrainz metadata.
    NS_MMD_1 = 'http://musicbrainz.org/ns/mmd-1.0#'
    
    # Namespace for MusicBrainz relations.
    NS_REL_1 = 'http://musicbrainz.org/ns/rel-1.0#'
    
    # Namespace for MusicBrainz extensions.
    NS_EXT_1 = 'http://musicbrainz.org/ns/ext-1.0#'
    
  end 
end

require 'rbrainz/data/countrynames'
require 'rbrainz/data/languagenames'
require 'rbrainz/data/scriptnames'

require 'rbrainz/model/mbid'
require 'rbrainz/model/artist'
require 'rbrainz/model/label'
require 'rbrainz/model/release'
require 'rbrainz/model/track'