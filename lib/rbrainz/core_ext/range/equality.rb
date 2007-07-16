# $Id$
#
# Author::    Nigel Graham (mailto:nigel_graham@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

module MusicBrainz
  module CoreExtensions # :nodoc:
    module Range #:nodoc:
    
      ##
      # Mixin module with equality operations for ranges.
      # The built-in Range class is currently missing functions to compare a 
      # Range with another Range. There exist 13 disjoint equality operations for ranges.
      # This mixin implements them all and a few extra operations for commonly used combinations.
      #
      module Equality
      
        # <tt>a.before?(b)</tt> is true, if _a_ ends before the beginning of _b_.
        # Same as <tt>b.after?(a)</tt>.
        # 
        #  |A------|
        #            |B------|
        def before?(b)
          if b.kind_of? ::Range
            self.open_end < b.begin
          else
            self.open_end < b
          end
        end
        alias :< :before?

        # <tt>a.after?(b)</tt> is true, if _a_ begins after the end of _b_.
        # Same as <tt>b.before?(a)</tt>.
        # 
        #            |A------|
        #  |B------|
        def after?(b)
          if b.kind_of? ::Range
            b.open_end < self.begin
          else
            b.succ < self.begin
          end
        end
        alias :> :after?

=begin comment
Allready exists in Range so we can't define it in the module
        def eql?(b)
          if b.kind_of? ::Range
            puts "Range class eql?"
            self.begin == b.begin && self.open_end == b.open_end
          else
            puts "b.class eql?"
            self.begin == b && self.open_end == b.succ
          end
        end
        alias :== :eql?
=end

        # <tt>a.meets_beginning_of?(b)</tt> is true, if _b_ begins exactly at the end of _a_.
        # Same as <tt>b.meets_end_of?(a)</tt>.
        # 
        #  |A------|
        #          |B------|
        def meets_beginning_of?(b)
          if b.kind_of? ::Range
            self.open_end == b.begin
          else
            self.open_end == b
          end
        end

        # <tt>a.meets_end_of?(b)</tt> is true, if _b_ ends exactly at the beginning of _a_.
        # Same as <tt>b.meets_beginning_of?(a)</tt>.
        # 
        #          |A------|
        #  |B------|
        def meets_end_of?(b)
          if b.kind_of? ::Range
            b.open_end == self.begin
          else
            b.succ == self.begin
          end
        end

        # <tt>a.overlaps_beginning_of?(b)</tt> is true, if _a_ overlaps the beginning of _b_.
        # Same as <tt>b.overlaps_end_of?(a)</tt>.
        # 
        #  |A------|
        #       |B------|
        def overlaps_beginning_of?(b)
          if b.kind_of? ::Range
            self.begin < b.begin && self.open_end < b.open_end && b.begin < self.open_end
          else
            false
          end
        end

        # <tt>a.overlaps_end_of?(b)</tt> is true, if _a_ overlaps the end of _b_.
        # Same as <tt>b.overlaps_beginning_of?(a)</tt>.
        # 
        #       |A------|
        #  |B------|
        def overlaps_end_of?(b)
          if b.kind_of? ::Range
            b.begin < self.begin && b.open_end < self.open_end && self.begin < b.open_end
          else
            false
          end
        end

        # <tt>a.during?(b)</tt> is true, if _a_ fits completely into _b_.
        # Same as <tt>b.contains?(a)</tt>.
        # 
        #     |A------|
        #  |B------------|
        def during?(b)
          if b.kind_of? ::Range
            b.begin < self.begin && self.open_end < b.open_end
          else
            false
          end
        end

        # <tt>a.contains?(b)</tt> is true, if _b_ fits completely into _a_.
        # Same as <tt>b.during?(a)</tt>.
        # 
        #  |A------------|
        #     |B------|
        def contains?(b)
          if b.kind_of? ::Range
            self.begin < b.begin && b.open_end < self.open_end
          else
            self.begin < b && b.succ < self.open_end
          end
        end

        # <tt>a.starts?(b)</tt> is true, if _a_ and _b_ have the same beginning
        # but _b_ lasts longer than _a_.
        # Same as <tt>b.started_by?(a)</tt>.
        # 
        #  |A------|
        #  |B-----------|
        def starts?(b)
          if b.kind_of? ::Range
            self.begin == b.begin && self.open_end < b.open_end
          else
            false
          end
        end

        # <tt>a.started_by?(b)</tt> is true, if _a_ and _b_ have the same
        # beginning but _a_ lasts longer than _b_.
        # Same as <tt>b.starts?(a)</tt>.
        # 
        #  |A-----------|
        #  |B------|
        def started_by?(b)
          if b.kind_of? ::Range
            b.begin == self.begin && b.open_end < self.open_end
          else
            b == self.begin && b.succ < self.open_end
          end
        end

        # <tt>a.finishes?(b)</tt> is true, if _a_ and _b_ have the same
        # end but _a_ begins after _b_.
        # Same as <tt>b.finished_by?(a)</tt>.
        # 
        #       |A------|
        #  |B-----------|
        def finishes?(b)
          if b.kind_of? ::Range
            b.begin < self.begin && self.open_end == b.open_end
          else
            false
          end
        end

        # <tt>a.finished_by?(b)</tt> is true, if _a_ and _b_ have the same
        # end but _b_ begins after _a_.
        # Same as <tt>b.finishes?(a)</tt>.
        # 
        #  |A-----------|
        #       |B------|
        def finished_by?(b)
          if b.kind_of? ::Range
            self.begin < b.begin && b.open_end == self.open_end
          else
            self.begin < b && b.succ == self.open_end
          end
        end

        # <tt>a <= b</tt> is the same as
        # <tt>a.before?(b) or a.meets_beginning_of?(b)</tt>
        def <=(b)
          self.before?(b) || self.meets_beginning_of?(b)
        end

        # <tt>a >= b</tt> is the same as
        # <tt>a.after?(b) or a.meets_end_of?(b)</tt>
        def >=(b)
          self.after?(b) || self.meets_end_of?(b)
        end

        # <tt>a.between?(b)</tt> is the same as
        # <tt>a.starts?(b) or a.during?(b) or a.finishes?(b)</tt>
        def between?(b)
          self.starts?(b) || self.during?(b) || self.finishes?(b)
        end

=begin comment
Allready exists in Range so we can't define it in the module
        def include?(b)
          self.started_by?(b) || self.contains?(b) || self.eql?(b) || self.finished_by?(b)
        end
=end

        protected
        def open_end
          if self.exclude_end?
            self.end
          else
            self.end.succ
          end
        end
      end
    end
  end
end
