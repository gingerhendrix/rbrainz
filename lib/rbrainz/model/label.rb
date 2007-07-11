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
    # See http://musicbrainz.org/doc/Label.
    class Label < Individual
    
      TYPE_UNKNOWN             = NS_MMD_1 + 'Unknown'
      TYPE_DISTRIBUTOR         = NS_MMD_1 + 'Distributor'
      TYPE_HOLDING             = NS_MMD_1 + 'Holding'
      TYPE_ORIGINAL_PRODUCTION = NS_MMD_1 + 'OriginalProduction'
      TYPE_BOOTLEG_PRODUCTION  = NS_MMD_1 + 'BootlegProduction'
      TYPE_REISSUE_PRODUCTION  = NS_MMD_1 + 'ReissueProduction'
      
      attr_accessor :code, :country
      
    end
    
  end
end