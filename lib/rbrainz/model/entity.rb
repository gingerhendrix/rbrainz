# $Id$
# Copyright (c) 2007, Philipp Wolfer
# All rights reserved.
# See LICENSE for permissions.
 
require 'rbrainz/model/mbid'

module MusicBrainz
  module Model

    # Superclass for all entities.
    # 
    # TODO: implement relations.
    class Entity
    
      attr_reader :id
      
      # Set the MBID.
      # 
      # +mbid+ should be an instance of +MBID+ or a string
      # representing either a complete MBID URI or just the
      # UUID part of it. If it is a complete URI the entity
      # part of the URI must match the entity type returned
      # by +entity_type+ or an +EntityTypeNotMatchingError+
      # will be raised.
      # 
      # Raises: +UnknownEntityError+, +InvalidUUIDError+,
      # +EntityTypeNotMatchingError+
      def id=(mbid)
        # If this already is an instance of MBID store it directly.
        if mbid.is_a? MBID
          @id = mbid
        else
          # Try to create an MBID from URI
          begin
            @id = MBID.from_uri(mbid)
          rescue InvalidMBIDError => e
            # Try it again and use mbid as the UUID
            @id = MBID.from_uuid(self.entity_type, mbid)
          end
        end
        
        # Check if the entity type of @id matches that of the current object.
        unless @id.entity == self.entity_type
          exception = EntityTypeNotMatchingError.new(@id.entity.to_s)
          @id = nil
          raise exception
        end
      end
      
      # Returns the entity type of the entity class.
      # 
      # Depending on the class this is <tt>:artist</tt>, <tt>:release</tt>,
      # <tt>:track</tt> or <tt>:label</tt>.
      def self.entity_type
        self.name.sub('MusicBrainz::Model::', '').downcase.to_sym
      end
      
      # Returns the entity type of the instance.
      # 
      # Depending on the class this is <tt>:artist</tt>, <tt>:release</tt>,
      # <tt>:track</tt> or <tt>:label</tt>.
      def entity_type
        self.class.entity_type
      end
      
    end
    
  end
end
