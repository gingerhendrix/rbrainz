# $Id$
# Copyright (c) 2007, Philipp Wolfer
# All rights reserved.
# See LICENSE for permissions.

module MusicBrainz
  module Model

    # Namespace for all MusicBrainz metadata.
    NS_MMD_1 = 'http://musicbrainz.org/ns/mmd-1.0#'
    
    # Namespace for MusicBrainz relations.
    NS_REL_1 = 'http://musicbrainz.org/ns/rel-1.0#'
    
    # Namespace for MusicBrainz extensions.
    NS_EXT_1 = 'http://musicbrainz.org/ns/ext-1.0#'

    # Defines the format of an UUID (Universally Unique Identifier)
    UUID_REGEXP = /^[a-f0-9]{8}(-[a-f0-9]{4}){3}-[a-f0-9]{12}$/
    
    # The format of a MusicBrainz identifier was wrong.
    class InvalidMBIDError < Exception
    end
    
    # The format of a MusicBrainz UUID was wrong.
    class InvalidUUIDError < Exception
    end
    
    # An unknown entity was encountered.
    # Valid entities are only :artist, :release, :track and :label.
    class UnknownEntityError < Exception
    end
    
    # The entity type of a MBID didn't match the type of the entity.
    class EntityTypeNotMatchingError < Exception
    end
    
  end 
end

require 'rbrainz/data/countrynames'
require 'rbrainz/data/languagenames'
require 'rbrainz/data/scriptnames'

require 'rbrainz/model/artist'
require 'rbrainz/model/label'
require 'rbrainz/model/release'
require 'rbrainz/model/track'