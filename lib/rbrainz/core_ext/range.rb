# $Id$
#
# Author::    Nigel Graham (mailto:nigel_graham@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require File.dirname(__FILE__) + '/range/equality'

class Range  #:nodoc:
  include MusicBrainz::CoreExtensions::Range::Equality

  alias :old_eql? :eql?
  def eql?(b)
    if b.kind_of? ::Range
      self.begin == b.begin && self.open_end == b.open_end
    else
      self.begin == b && self.open_end == b.succ
    end
  end
  remove_method :==
  alias :== :eql?

  alias :old_include? :include?
  def include?(b)
    self.started_by?(b) || self.contains?(b) || self.eql?(b) || self.finished_by?(b)
  end
end