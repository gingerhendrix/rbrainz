# $Id$
# Copyright (c) 2007, Philipp Wolfer
# All rights reserved.
# See LICENSE for permissions.

require 'rbrainz/model/entity'
require 'rbrainz/model/incomplete_date'

module MusicBrainz
  module Model

    # A label in the MusicBrainz DB.
    # 
    # See http://musicbrainz.org/doc/Label.
    class Label < Entity
    
      attr_accessor :name, :sort_name, :disambiguation,
                    :code, :country, :type,
                    :founding_date, :dissolving_date
      
    end
    
  end
end