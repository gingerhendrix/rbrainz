require File.dirname(__FILE__) + '/range/equality'

class Range  #:nodoc:
  include MusicBrainz::Range::Equality
end