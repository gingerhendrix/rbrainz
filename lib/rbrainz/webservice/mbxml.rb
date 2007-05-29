# $Id$
# Copyright (c) 2007, Philipp Wolfer
# All rights reserved.
# See LICENSE for permissions.

require 'rbrainz/model'
require 'rexml/document'
include REXML

module MusicBrainz
  module Webservice

    # Class to read the XML data returned by the MusicBrainz
    # webservice and create the corresponding model classes.
    # The class understands the MusicBrainz XML Metadata Version 1.0
    # schema.
    # 
    # See http://musicbrainz.org/doc/MusicBrainzXMLMetaData for more
    # information on the MusicBrainz XML Metadata schema.
    class MBXML
    
      def initialize(xml)
        @document = Document.new(xml)
        
        # Already loaded artists, releases, tracks
        # and labels will get cached in these variables
        # to link to them if they occure multiple times
        # inside the same document.
        @artists  = Hash.new
        @releases = Hash.new
        @tracks   = Hash.new
        @labels   = Hash.new
      end
      
      # Read the XML string and create an entity model
      # for the given entity type if it is present in 
      # the document.
      # Returns nil if no entity of the given type is present.
      def get_entity(entity_type)
        # Search for the first occuring node of type entity which is a child node
        # of the metadata element.
        entity = @document.elements["//[local-name()='metadata' and namespace-uri()='%s']/%s[1]" %
                 [Model::NS_MMD_1, entity_type]]
        
        unless entity.nil? or entity.is_a? REXML::Text
          case entity.name
          when 'artist'
            return create_artist(entity)
          when 'release'
            return create_release(entity)
          when 'track'
            return create_track(entity)
          when 'label'
            return create_label(entity)
          end
        else
          return nil
        end
      end
      
      # Read the XML string and create a list of entity
      # models for the given entity type. Ther must be
      # an entity-list element as a child of the metadata
      # element in the document.
      # Returns nil if no entity list of the given type is present.
      # Returns an empty array if the list is empty.
      def get_entity_list(entity_type)
        # Search for the first occuring node of type entity which is a child node
        # of the metadata element.
        entity_list = @document.elements["//[local-name()='metadata' and namespace-uri()='%s']/%s-list[1]" %
                      [Model::NS_MMD_1, entity_type]]
        
        unless entity_list.nil? or entity_list.is_a? REXML::Text
          list = Array.new
          
          case entity_list.name
          when 'artist-list'
            read_artist_list(entity_list) {|model|
              list << model
            }
            return list
          when 'release-list'
            read_release_list(entity_list) {|model|
              list << model
            }
            return list
          when 'track-list'
            read_track_list(entity_list) {|model|
              list << model
            }
            return list
          when 'label-list'
            read_label_list(entity_list) {|model|
              list << model
            }
            return list
          end
          
          if iterator
            list = Array.new
            iterator.each {|model|
              raise model.inspect
              list << model
            }
            return list
          end
        end
        return nil
      end
      
      private # ----------------------------------------------------------------
      
      # Iterate over a list of artists.
      # 
      # The node must be of the type <em>artist-list</em>.
      def read_artist_list(node)
        node.elements.each('artist') {|child|
          yield create_artist(child)
        }
      end
      
      # Create an +Artist+ object from the given artist node.
      def create_artist(node)
        if node.attributes['id'] and @artists[node.attributes['id']]
          artist = @artists[node.attributes['id']]
        else
          artist = Model::Artist.new
          @artists[node.attributes['id']] = artist
        end
        
        # Read all defined data fields
        artist.id = node.attributes['id']
        if node.attributes['type']
          artist.type = MBXML.add_namespace(node.attributes['type'], Model::NS_MMD_1)
        end
        
        artist.name = node.elements['name'].text if node.elements['name']
        artist.sort_name = node.elements['sort-name'].text if node.elements['sort-name']
        artist.disambiguation = node.elements['disambiguation'].text if node.elements['disambiguation']
        
        if life_span = node.elements['life-span']
          if life_span.attributes['begin']
            artist.begin_date = Model::IncompleteDate.new life_span.attributes['begin']
          end
          if life_span.attributes['end']
            artist.end_date = Model::IncompleteDate.new life_span.attributes['end']
          end
        end
        
        # Read the alias list
        if node.elements['alias-list']
          read_alias_list(node.elements['alias-list']) {|artist_alias|
            artist.aliases << artist_alias
          }
        end
        
        # Read the release list
        if node.elements['release-list']
          read_release_list(node.elements['release-list']) {|release|
            release.artist = artist unless release.artist
            artist.releases << release
          }
        end
        
        # Read the relation list
        if node.elements['relation-list']
          node.elements.each('relation-list') {|relation_node|
            read_relation_list(relation_node) {|relation|
              artist.add_relation relation
            }
          }
        end
        
        return artist
      end
      
      # Iterate over a list of releases.
      # 
      # The node must be of the type <em>release-list</em>.
      def read_release_list(node)
        node.elements.each('release') {|child|
          yield create_release(child)
        }
      end
      
      # Create a +Release+ object from the given release node.
      # 
      # TODO: PUID list
      def create_release(node)
        if node.attributes['id'] and @releases[node.attributes['id']]
          release = @releases[node.attributes['id']]
        else
          release = Model::Release.new
          @releases[node.attributes['id']] = release
        end
        
        # Read all defined data fields
        release.id     = node.attributes['id']
        release.title  = node.elements['title'].text if node.elements['title']
        release.asin   = node.elements['asin'].text if node.elements['asin']
        release.artist = create_artist(node.elements['artist']) if node.elements['artist']
        
        # Read the types
        node.attributes['type'].split(' ').each {|type|
          release.types << MBXML.add_namespace(type, Model::NS_MMD_1)
        } if node.attributes['type']
        
        # Read the text representation information.
        if text_representation = node.elements['text-representation']
          release.text_language = text_representation.attributes['language']
          release.text_script = text_representation.attributes['script']
        end
        
        # Read the track list
        if node.elements['track-list']
          read_track_list(node.elements['track-list']) {|track|
            track.artist = release.artist unless track.artist
            track.releases << release
            release.tracks << track
          }
        end
        
        # Read the release event list
        if node.elements['release-event-list']
          read_release_event_list(node.elements['release-event-list']) {|event|
            release.release_events << event
          }
        end
        
        # Read the disc list
        if node.elements['disc-list']
          read_disc_list(node.elements['disc-list']) {|disc|
            release.discs << disc
          }
        end
        
        # Read the relation list
        if node.elements['relation-list']
          node.elements.each('relation-list') {|relation_node|
            read_relation_list(relation_node) {|relation|
              release.add_relation relation
            }
          }
        end
        
        return release
      end
      
      # Iterate over a list of tracks.
      # 
      # The node must be of the type <em>track-list</em>.
      def read_track_list(node)
        node.elements.each('track') {|child|
          yield create_track(child)
        }
      end
      
      # Create a +Track+ object from the given track node.
      def create_track(node)
        if node.attributes['id'] and @tracks[node.attributes['id']]
          track = @tracks[node.attributes['id']]
        else
          track = Model::Track.new
          @tracks[node.attributes['id']] = track
        end
        
        # Read all defined data fields
        track.id       = node.attributes['id']
        track.title    = node.elements['title'].text if node.elements['title']
        track.duration = node.elements['duration'].text.to_i if node.elements['duration']
        track.artist   = create_artist(node.elements['artist']) if node.elements['artist']
        
        # Read the release list
        if node.elements['release-list']
          read_release_list(node.elements['release-list']) {|release|
            release.tracks << track
            track.releases << release
          }
        end
        
        # Read the PUID list
        if node.elements['puid-list']
          read_puid_list(node.elements['puid-list']) {|puid|
            track.puids << puid
          }
        end
        
        # Read the relation list
        if node.elements['relation-list']
          node.elements.each('relation-list') {|relation_node|
            read_relation_list(relation_node) {|relation|
              track.add_relation relation
            }
          }
        end
        
        return track
      end
      
      # Iterate over a list of labels.
      # 
      # The node must be of the type <em>label-list</em>.
      def read_label_list(node)
        node.elements.each('label') {|child|
          yield create_label(child)
        }
      end
      
      # Create a +Label+ object from the given label node.
      def create_label(node)
        if node.attributes['id'] and @labels[node.attributes['id']]
          label = @labels[node.attributes['id']]
        else
          label = Model::Label.new
          @labels[node.attributes['id']] = label
        end
        
        # Read all defined data fields
        label.id = node.attributes['id']
        if node.attributes['type']
          label.type = MBXML.add_namespace(node.attributes['type'], Model::NS_MMD_1)
        end
        
        label.name = node.elements['name'].text if node.elements['name']
        label.sort_name = node.elements['sort-name'].text if node.elements['sort-name']
        label.code = node.elements['label-code'].text if node.elements['label-code']
        label.disambiguation = node.elements['disambiguation'].text if node.elements['disambiguation']
        label.country = node.elements['country'].text if node.elements['country']
        
        if life_span = node.elements['life-span']
          if life_span.attributes['begin']
            label.founding_date = Model::IncompleteDate.new life_span.attributes['begin']
          end
          if life_span.attributes['end']
            label.dissolving_date = Model::IncompleteDate.new life_span.attributes['end']
          end
        end
        
        # Read the alias list
        if node.elements['release-list']
          read_release_list(node.elements['release-list']) {|release|
            label.releases << release
          }
        end
      
        # Read the relation list
        if node.elements['relation-list']
          node.elements.each('relation-list') {|relation_node|
            read_relation_list(relation_node) {|relation|
              label.add_relation relation
            }
          }
        end
        
        return label  
      end
      
      # Iterate over a list of aliases.
      # 
      # The node must be of the type <em>alias-list</em>.
      def read_alias_list(node)
        node.elements.each('alias') {|child|
          yield create_alias(child)
        }
      end
      
      # Create an +Alias+ object from the given alias node.
      def create_alias(node)
        alias_model = Model::Alias.new
        alias_model.name = node.text
        alias_model.type = node.attributes['type']
        alias_model.script = node.attributes['script']
        return alias_model
      end
      
      # Iterate over a list of release events.
      # 
      # The node must be of the type <em>release-event-list</em>.
      def read_release_event_list(node)
        node.elements.each('event') {|child|
          yield create_release_event(child)
        }
      end
      
      # Create an +ReleaseEvent+ object from the given release event node.
      def create_release_event(node)
        event = Model::ReleaseEvent.new
        
        # Read all defined data fields
        if node.attributes['date']
          event.date = Model::IncompleteDate.new node.attributes['date']
        end
        event.country = node.attributes['country']
        event.catalog_number = node.attributes['catalog-number']
        event.barcode = node.attributes['barcode']
        event.label   = create_label(node.elements['label']) if node.elements['label']
        
        return event
      end
      
      # Iterate over a list of PUIDs.
      # 
      # The node must be of the type <em>puid-list</em>.
      def read_puid_list(node)
        node.elements.each('puid') {|child|
          yield child.attributes['id']
        }
      end
      
      # Iterate over a list of discs.
      # 
      # The node must be of the type <em>disc-list</em>.
      def read_disc_list(node)
        node.elements.each('disc') {|child|
          disc = Model::Disc.new
          disc.id = child.attributes['id']
          disc.sectors = child.attributes['sectors'].to_i
          yield disc
        }
      end
      
      # Iterate over a list of relations.
      # 
      # The node must be of the type <em>relation-list</em>.
      def read_relation_list(node)
        node.elements.each('relation') {|child|
          target_type = MBXML.add_namespace(node.attributes['target-type'], Model::NS_REL_1)
          yield create_relation(child, target_type)
        }
      end
      
      # Create a +Relation+ object from the given relation node.
      def create_relation(node, target_type)
        relation = Model::Relation.new
        
        # Read all defined data fields
        if node.attributes['direction']
          relation.direction = node.attributes['direction'].to_sym
        end
        
        if node.attributes['type']
          relation.type = MBXML.add_namespace(node.attributes['type'], Model::NS_REL_1)
        end
        
        if node.attributes['begin']
          relation.begin_date = Model::IncompleteDate.new node.attributes['begin']
        end
        
        if node.attributes['end']
          relation.begin_end = Model::IncompleteDate.new node.attributes['end']
        end
        
        if node.attributes['attributes']
          node.attributes['attributes'].split(' ').each {|attribute|
            relation.attributes << MBXML.add_namespace(attribute, Model::NS_REL_1)
          }
        end
        
        # Set the target. Either use the target included in the relation
        # or create a new target according to the target type if no target
        # is present.
        case target_type
        when Model::Relation::TO_ARTIST
          if node.elements['artist']
            target = create_artist node.elements['artist']
          else
            target = Model::Artist.new
            target.id = Model::MBID.from_uuid(:artist, node.attributes['target'])
          end
        when Model::Relation::TO_RELEASE
          if node.elements['release']
            target = create_release node.elements['release']
          else
            target = Model::Release.new
            target.id = Model::MBID.from_uuid(:release, node.attributes['target'])
          end
        when Model::Relation::TO_TRACK
          if node.elements['track']
            target = create_track node.elements['track']
          else
            target = Model::Track.new
            target.id = Model::MBID.from_uuid(:track, node.attributes['target'])
          end
        when Model::Relation::TO_LABEL
          if node.elements['label']
            target = create_label node.elements['label']
          else
            target = Model::Label.new
            target.id = Model::MBID.from_uuid(:label, node.attributes['target'])
          end
        when Model::Relation::TO_URL
          target = node.attributes['target']
        end
        
        relation.target = target
        
        return relation
      end
      
      # Helper method which will return the given property
      # extended by the namespace. If the property
      # already includes the namespace it will be returned
      # unchanged.
      def self.add_namespace(property, namespace)
        regex = Regexp.new("/#{namespace}[a-z-]/i")
        unless property =~ regex
          return namespace + property
        else
          return property
        end
      end
      
    end

  end
end