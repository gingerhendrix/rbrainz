# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'rbrainz/model/individual'

module MusicBrainz
  module Model

    # A label in the MusicBrainz DB.
    # 
    # Labels in MusicBrainz can have a type. Currently, the following types
    # are supported
    # 
    # - http://musicbrainz.org/ns/mmd-1.0#Unknown
    # - http://musicbrainz.org/ns/mmd-1.0#Distributor
    # - http://musicbrainz.org/ns/mmd-1.0#Holding
    # - http://musicbrainz.org/ns/mmd-1.0#OriginalProduction
    # - http://musicbrainz.org/ns/mmd-1.0#BootlegProduction
    # - http://musicbrainz.org/ns/mmd-1.0#ReissueProduction
    #
    # See:: Individual
    # See:: http://musicbrainz.org/doc/Label.
    class Label < Individual
    
      # Used if the type of the label is unknown.
      TYPE_UNKNOWN             = NS_MMD_1 + 'Unknown'
      # Companies mainly distributing other labels production,
      # usually in a specific region of the world.
      TYPE_DISTRIBUTOR         = NS_MMD_1 + 'Distributor'
      # Holdings, conglomerates or other financial entities whose main
      # activity is not to produce records, but to manage a large set of
      # recording labels owned by them.
      TYPE_HOLDING             = NS_MMD_1 + 'Holding'
      # Recording labels producing entirely new releases.
      TYPE_ORIGINAL_PRODUCTION = NS_MMD_1 + 'OriginalProduction'
      # Bootlegs companies (as in "not sanctioned by the rights owner(s)
      # of the released work")
      TYPE_BOOTLEG_PRODUCTION  = NS_MMD_1 + 'BootlegProduction'
      # Labels specializing in catalog reissues.
      TYPE_REISSUE_PRODUCTION  = NS_MMD_1 + 'ReissueProduction'
      
      # See Entity::ENTITY_TYPE.
      ENTITY_TYPE = :label # :nodoc:
      
      # The code of the label.
      # 
      # See:: http://musicbrainz.org/doc/LabelCode
      attr_accessor :code
      
      # The country in which the company was founded.
      # A string containing a ISO 3166 country code like
      # 'GB', 'US' or 'DE'.
      # 
      # See:: COUNTRY_NAMES in Model::Data
      # See:: http://musicbrainz.org/doc/LabelCountry
      attr_accessor :country
      
    end
    
  end
end