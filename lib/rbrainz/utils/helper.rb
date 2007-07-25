# $Id$
#
# Author::    Nigel Graham, Philipp Wolfer
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

module MusicBrainz
  module Utils
  
    class << self
    
      # Remove the given _namespace_ from _str_. Will return _str_ with the
      # namespace removed. If the namespace was not present in _str_ it will
      # be returned unchanged.
      def remove_namespace(str, namespace=Model::NS_MMD_1)
        if str =~ /^#{namespace}(.*)/
          return $1 
        else
          return str
        end
      end
      
      # Will return the given _str_ extended by _namespace_. If _str_ already
      # includes the namespace or if _str_ is empty it will be returned unchanged.
      def add_namespace(str, namespace=Model::NS_MMD_1)
        unless str =~ /^#{namespace}/ or str.to_s.empty?
          return namespace + str
        else
          return str
        end
      end
      
      # Check an options hash for required options.
      # Raises an ArgumentError if unknown options are present in the hash.
      def check_options(options, *optdecl)   # :nodoc:
        h = options.dup
        optdecl.each do |name|
          h.delete name
        end
        raise ArgumentError, "no such option: #{h.keys.join(' ')}" unless h.empty?
      end
    
    end
      
  end
end