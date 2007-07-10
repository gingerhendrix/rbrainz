# $Id$
#
# Author::    Nigel Graham (mailto:nigel_graham@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.
module MusicBrainz #:nodoc:
  module CoreExtensions # :nodoc:
    module Range #:nodoc:
    
      ##
      # Mixin module with equality operations for ranges.
      # The built-in Range class is currently missing functions to compare a 
      # Range with another Range. There exists 13 disjoint equality operations for ranges.
      # This mixin implements them all and a few extra operations for commonly used combinations.
      #
      module Equality
        def before?(b)
          if b.kind_of? ::Range
            self.open_end < b.begin
          else
            self.open_end < b
          end
        end
        alias :< :before?

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

        def meets_beginning_of?(b)
          if b.kind_of? ::Range
            self.open_end == b.begin
          else
            self.open_end == b
          end
        end

        def meets_end_of?(b)
          if b.kind_of? ::Range
            b.open_end == self.begin
          else
            b.succ == self.begin
          end
        end

        def overlaps_beginning_of?(b)
          if b.kind_of? ::Range
            self.begin < b.begin && self.open_end < b.open_end && b.begin < self.open_end
          else
            false
          end
        end

        def overlaps_end_of?(b)
          if b.kind_of? ::Range
            b.begin < self.begin && b.open_end < self.open_end && self.begin < b.open_end
          else
            false
          end
        end

        def during?(b)
          if b.kind_of? ::Range
            b.begin < self.begin && self.open_end < b.open_end
          else
            false
          end
        end

        def contains?(b)
          if b.kind_of? ::Range
            self.begin < b.begin && b.open_end < self.open_end
          else
            self.begin < b && b.succ < self.open_end
          end
        end

        def starts?(b)
          if b.kind_of? ::Range
            self.begin == b.begin && self.open_end < b.open_end
          else
            false
          end
        end

        def started_by?(b)
          if b.kind_of? ::Range
            b.begin == self.begin && b.open_end < self.open_end
          else
            b == self.begin && b.succ < self.open_end
          end
        end

        def finishes?(b)
          if b.kind_of? ::Range
            b.begin < self.begin && self.open_end == b.open_end
          else
            false
          end
        end

        def finished_by?(b)
          if b.kind_of? ::Range
            self.begin < b.begin && b.open_end == self.open_end
          else
            self.begin < b && b.succ == self.open_end
          end
        end

        def <=(b)
          self.before?(b) || self.meets_beginning_of?(b)
        end

        def >=(b)
          self.after?(b) || self.meets_end_of?(b)
        end

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
