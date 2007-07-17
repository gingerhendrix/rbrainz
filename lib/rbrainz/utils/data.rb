# $Id$
#
# Helper methods to deal with MusicBrainz data.
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'rbrainz/data/countrynames'
require 'rbrainz/data/languagenames'
require 'rbrainz/data/scriptnames'
require 'rbrainz/data/releasetypenames'

module MusicBrainz

  # This module contains helper functions to make common tasks easier.
  module Utils
  
    # Returns a country's name based on an ISO-3166 country code.
    #
    # The country table this function is based on has been modified for
    # MusicBrainz purposes by using the extension mechanism defined in ISO-3166.
    # All IDs are still valid ISO-3166 country codes, but some IDs have been
    # added to include historic countries and some of the country names have
    # been modified to make them better suited for display purposes.
    # 
    # If the country ID is not found, +nil+ is returned. This may happen for
    # example, when new countries are added to the MusicBrainz web service which
    # aren't known to this library yet.
    # 
    # See:: #Data::COUNTRY_NAMES
    def self.get_country_name(id)
      return Data::COUNTRY_NAMES[id]
    end
    
    # Returns a language name based on an ISO-639-2/T code.
    # 
    # This function uses a subset of the ISO-639-2/T code table to map language
    # IDs (terminologic, not bibliographic ones!) to names.
    # 
    # If the language ID is not found, +nil+ is returned. This may happen for
    # example, when new languages are added to the MusicBrainz web service which
    # aren't known to this library yet.
    # 
    # See:: #Data::LANGUAGE_NAMES
    def self.get_language_name(id)
      return Data::LANGUAGE_NAMES[id]
    end
    
    # Returns a script name based on an ISO-15924 code.
    # 
    # This function uses a subset of the ISO-15924 code table to map script
    # IDs to names.
    # 
    # If the script ID is not found, +nil+ is returned. This may happen for
    # example, when new scripts are added to the MusicBrainz web service which
    # aren't known to this library yet.
    # 
    # See:: #Data::SCRIPT_NAMES
    def self.get_script_name(id)
      return Data::SCRIPT_NAMES[id]
    end
    
    # Returns the name of a release type URI.
    # 
    # If the release type is not found, +nil+ is returned. This may happen for
    # example, when new release types are added to the MusicBrainz web service
    # which aren't known to this library yet.
    # 
    # See:: #Data::RELEASE_TYPE_NAMES
    # See:: Model::Release
    def self.get_release_type_name(id)
      return Data::RELEASE_TYPE_NAMES[id]
    end
    
  end
end