# $Id$
# Copyright (c) 2007, Philipp Wolfer
# All rights reserved.
# See LICENSE for permissions.

module MusicBrainz
  module Model

    # Defines the format of an UUID (Universally Unique Identifier)
    UUID_REGEXP = /^[a-z0-9]{8}(-[a-z0-9]{4}){3}-[a-z0-9]{12}$/
    
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
    
    # An unknown artist type was encountered.
    # See Model::Artist::TYPES for a list of valid artist types.
    class UnknownArtistTypeError < Exception
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