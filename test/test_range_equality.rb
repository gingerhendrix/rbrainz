# $Id$
#
# Author::    Nigel Graham (mailto:nigel_graham@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'test/unit'
require 'rbrainz'

# Unit test for range equality extension.
class TestRangeEquality < Test::Unit::TestCase
  TESTSET = 
    [
      [  1..11,  13..30,                :before?], # a before b
      [ 1...12, 13...30,                :before?], # a before b
      [  1..11,      13,                :before?], # a before b
      [ 13..30,   1..11,                 :after?], # a after b
      [13...30,  1...12,                 :after?], # a after b
      [ 13..30,      11,                 :after?], # a after b
      [  1..12,  1...13,                   :eql?], # a equals b
      [  1..12,   1..12,                   :eql?], # a equals b
      [ 1...13,   1..12,                   :eql?], # a equals b
      [ 1...13,  1...13,                   :eql?], # a equals b
      [  1...2,       1,                   :eql?], # a equals b
      [   1..1,       1,                   :eql?], # a equals b
      [ 1...13,  13..30,    :meets_beginning_of?], # a meets_beginning_of b
      [  1..12,  13..30,    :meets_beginning_of?], # a meets_beginning_of b
      [ 1...13,      13,    :meets_beginning_of?], # a meets_beginning_of b
      [  1..12,      13,    :meets_beginning_of?], # a meets_beginning_of b
      [ 13..30,  1...13,          :meets_end_of?], # a meets_end_of b
      [ 13..30,   1..12,          :meets_end_of?], # a meets_end_of b
      [ 13..30,      12,          :meets_end_of?], # a meets_end_of b
      [  1..13,  13..30, :overlaps_beginning_of?], # a overlaps_beginning_of b
      [ 1...14,  13..30, :overlaps_beginning_of?], # a overlaps_beginning_of b
      [  1..29,  13..30, :overlaps_beginning_of?], # a overlaps_beginning_of b
      [ 1...30,  13..30, :overlaps_beginning_of?], # a overlaps_beginning_of b
      [ 13..30,   1..13,       :overlaps_end_of?], # a overlaps_end_of b
      [ 13..30,  1...14,       :overlaps_end_of?], # a overlaps_end_of b
      [ 13..30,   1..29,       :overlaps_end_of?], # a overlaps_end_of b
      [ 13..30,  1...30,       :overlaps_end_of?], # a overlaps_end_of b
      [ 13..30,  12..31,                :during?], # a during b
      [13...30,  12..30,                :during?], # a during b
      [13...30, 12...31,                :during?], # a during b
      [ 13..30, 12...32,                :during?], # a during b
      [ 12..31,  13..30,              :contains?], # a contains b
      [ 12..30, 13...30,              :contains?], # a contains b
      [12...31, 13...30,              :contains?], # a contains b
      [12...32,  13..30,              :contains?], # a contains b
      [12...32,      13,              :contains?], # a contains b
      [ 13..30,  13..31,                :starts?], # a starts b
      [13...30,  13..30,                :starts?], # a starts b
      [ 13..30, 13...32,                :starts?], # a starts b
      [13...30, 13...31,                :starts?], # a starts b
      [ 13..31,  13..30,            :started_by?], # a started_by b
      [ 13..30, 13...30,            :started_by?], # a started_by b
      [13...32,  13..30,            :started_by?], # a started_by b
      [13...31, 13...30,            :started_by?], # a started_by b
      [13...31,      13,            :started_by?], # a started_by b
      [ 14..30,  13..30,              :finishes?], # a finishes b
      [14...30,  13..29,              :finishes?], # a finishes b
      [ 14..30, 13...31,              :finishes?], # a finishes b
      [14...30, 13...30,              :finishes?], # a finishes b
      [ 13..30,  14..30,           :finished_by?], # a finished_by b
      [ 13..29, 14...30,           :finished_by?], # a finished_by b
      [13...31,  14..30,           :finished_by?], # a finished_by b
      [13...30, 14...30,           :finished_by?], # a finished_by b
      [13...30,      29,           :finished_by?], # a finished_by b
    ]
  OPERATIONS = [
      :before?,
      :after?,
      :eql?,
      :meets_beginning_of?,
      :meets_end_of?,
      :overlaps_beginning_of?,
      :overlaps_end_of?,
      :during?,
      :contains?,
      :starts?,
      :started_by?,
      :finishes?,
      :finished_by?,
    ]
  
  def self.make_test_method(s)
    st = s.to_s.chop
    class_eval %Q{
      def test_#{st}
        TESTSET.each do |a,b,op|
          if op == #{s.inspect}
            assert a.send(#{s.inspect}, b), a.inspect + ".#{s.to_s} " + b.inspect
          else
            assert !a.send(#{s.inspect},b), '!' + a.inspect + ".#{s.to_s} " + b.inspect
          end
        end
      end
    }, __FILE__
  end
  
  OPERATIONS.each do |op|
    make_test_method(op)
  end

  def test_lteq
    TESTSET.each do |a,b,op|
      if op == :before? || op == :meets_beginning_of?
        assert a <= b, a.inspect + " <= " + b.inspect
      else
        assert !(a <= b), '!(' + a.inspect + " <= " + b.inspect + ')'
      end
    end
  end

  def test_gteq
    TESTSET.each do |a,b,op|
      if op == :after? || op == :meets_end_of?
        assert a >= b, a.inspect + " >= " + b.inspect
      else
        assert !(a >= b), '!(' + a.inspect + " >= " + b.inspect + ')'
      end
    end
  end

  def test_between
    TESTSET.each do |a,b,op|
      if op == :starts? || op == :during? || op == :finishes?
        assert a.between?(b), a.inspect + ".between? " + b.inspect
      else
        assert !a.between?(b), '!' + a.inspect + ".between? " + b.inspect + ''
      end
    end
  end

  def test_include
    TESTSET.each do |a,b,op|
      if op == :started_by? || op == :contains? || op == :eql? || op == :finished_by?
        assert a.include?(b), a.inspect + ".include? " + b.inspect
      else
        assert !a.include?(b), '!' + a.inspect + ".include? " + b.inspect + ''
      end
    end
  end
end
