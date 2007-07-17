# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'rbrainz/model/individual'
require 'rbrainz/model/alias'

module MusicBrainz
  module Model

    #
    # An artist in the MusicBrainz DB.
    #
    # Artists in MusicBrainz can have a type. Currently, this type can
    # be either Person or Group for which the following URIs are assigned:
    #
    # - http://musicbrainz.org/ns/mmd-1.0#Person
    # - http://musicbrainz.org/ns/mmd-1.0#Group
    #
    # Use the TYPE_PERSON and TYPE_GROUP constants for comparison.
    #
    # See:: Individual
    # See:: http://musicbrainz.org/doc/Artist.
    class Artist < Individual
    
      # Used if the type of the artist is unknown.
      TYPE_UNKNOWN = NS_MMD_1 + 'Unknown'
      # This indicates an individual person.
      TYPE_PERSON  = NS_MMD_1 + 'Person'
      # This indicates a group of people that may or may
      # not have a distinctive name.
      TYPE_GROUP   = NS_MMD_1 + 'Group'
    
      # See Entity::ENTITY_TYPE.
      ENTITY_TYPE = :artist # :nodoc:
      
    end

  end
end