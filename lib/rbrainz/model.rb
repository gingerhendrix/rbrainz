# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

module MusicBrainz # :nodoc:

  # The MusicBrainz domain model.
  # These classes are part of the MusicBrainz domain model. They may be used
  # by other modules and don't contain any network or other I/O code. If you
  # want to request data from the web service, please have a look at
  # Webservice::Query.
  # 
  # The most important classes, usually acting as entry points, are
  # Artist, Release, Track and Label.
  # 
  # See:: Webservice
  module Model

    # Namespace for all MusicBrainz metadata.
    NS_MMD_1 = 'http://musicbrainz.org/ns/mmd-1.0#'
    
    # Namespace for MusicBrainz relations.
    NS_REL_1 = 'http://musicbrainz.org/ns/rel-1.0#'
    
    # Namespace for MusicBrainz extensions.
    NS_EXT_1 = 'http://musicbrainz.org/ns/ext-1.0#'
   
    require 'rbrainz/model/default_factory'
    require 'rbrainz/utils'
    require 'rbrainz/core_ext'
    
    # The ID of the special 'Various Artists' artist. This is an instance of MBID.
    # See:: http://musicbrainz.org/doc/VariousArtists
    VARIOUS_ARTISTS_ID = MBID.new('89ad4ac3-39f7-470e-963a-56509c546377', Artist.entity_type)
  
  end 
end