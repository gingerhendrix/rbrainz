# $Id$
#
# This is actually just a convenient shortcut that allows
# the user to use RBrainz by just using <tt>require 'rbrainz'</tt>.
# This will include the whole RBrainz webservice library, which 
# should be ok most of the time.
# 
# If you want only the models use <tt>require 'rbrainz/model'</tt>.
# 
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'rbrainz/webservice'
require 'rbrainz/core_ext'
