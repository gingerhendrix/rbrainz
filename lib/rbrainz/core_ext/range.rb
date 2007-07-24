# $Id$
#
# Author::    Nigel Graham (mailto:nigel_graham@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require File.dirname(__FILE__) + '/range/equality'

class Range  #:nodoc:

  # Extend Range with additional comparison operations.
  include MusicBrainz::CoreExtensions::Range::Equality
  
end