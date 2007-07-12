# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.
#require 'rbrainz/core_ext'

module MusicBrainz
=begin rdoc
    The MusicBrainz domain model.

    These classes are part of the MusicBrainz domain model. They may be used
    by other modules and don't contain any network or other I/O code. If you
    want to request data from the web service, please have a look at
    Webservice::Query.

    The most important classes, usually acting as entry points, are
    Artist, Release, Track and Label.

    See:: Webservice
=end
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

require 'rbrainz/model/artist'
require 'rbrainz/model/label'
require 'rbrainz/model/release'
require 'rbrainz/model/track'
require 'rbrainz/model/user'