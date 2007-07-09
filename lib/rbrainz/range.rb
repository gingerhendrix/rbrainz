require File.dirname(__FILE__) + '/range/equality'

class Range  #:nodoc:
  include MusicBrainz::Range::Equality

  def eql?(b)
    if b.kind_of? ::Range
      self.begin == b.begin && self.open_end == b.open_end
    else
      self.begin == b && self.open_end == b.succ
    end
  end
  alias :== :eql?

  def include?(b)
    self.started_by?(b) || self.contains?(b) || self.eql?(b) || self.finished_by?(b)
  end
end