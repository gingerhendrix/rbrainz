# $Id$
#
# Author::    Nigel Graham, Philipp Wolfer
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

module MusicBrainz
  module Utils
  
    # Check an options hash for required options.
    # Raises an ArgumentError if unknown options are present in the hash.
    def self.check_options(options, *optdecl)   #:nodoc:
      h = options.dup
      optdecl.each do |name|
        h.delete name
      end
      raise ArgumentError, "no such option: #{h.keys.join(' ')}" unless h.empty?
    end
      
  end
end