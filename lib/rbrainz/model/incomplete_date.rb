# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'date'

module MusicBrainz
  module Model

    # Represents an incomplete date. An incomplete date is a date which can be
    # defined without day or without month and day. It can be written as
    # <em>YYYY</em>, <em>YYYY-MM</em> or <em>YYYY-MM-DD</em>.
    # 
    # An IncompleteDate is a Range of Date objects. The incomplete date
    # <em>1969-01</em> for example results in a range beginning on 1969-01-01
    # and ending on 1969-01-31, including the end.
    # 
    # RBrainz extends the Ruby Range class with additional comparison methods.
    # See CoreExtensions::Range::Equality for a description of those methods.
    class IncompleteDate < ::Range
      attr_reader :year, :month, :day

      # Create a new IncompleteDate. The parameter _date_ must be a String in
      # the form <em>YYYY</em>, <em>YYYY-MM</em> or <em>YYYY-MM-DD</em>.
      def initialize(date)
        date = date.to_s if date.respond_to? :to_s
        if date =~ /^(\d{4})(?:-(\d{2})(?:-(\d{2}))?)?$/
          @year = $1.to_i
          @month = $2 ? $2.to_i : nil
          @day = $3 ? $3.to_i : nil
          if @month
            if @day
              start_d = Date.civil( @year, @month, @day)
              end_d = start_d
            else
              start_d = Date.civil( @year, @month)
              end_d = Date.civil( @year, @month, -1)
            end
          else
            start_d = Date.civil( @year)
            end_d = Date.civil( @year, -1, -1)
          end
          super( start_d, end_d)
        else
          raise ArgumentError, "Invalid incomplete date #{date}"
        end
      end

      # Returns the incomplete date in its textual form
      # <em>YYYY</em>, <em>YYYY-MM</em> or <em>YYYY-MM-DD</em>.
      # 
      # TODO: Allow formatting options similiar to Date.to_s
      def to_s
        date = @year.to_s
        [@month, @day].each {|value|
          date += '-%02d' % value if value
        }
        return date
      end
      
      # Compare two IncompleteDate objects for equality.
      # 
      # You can compare an IncompleteDate with another IncompleteDate, with
      # a Range of Date objects or directly with a Date. The following examples
      # all return true:
      # 
      #  IncompleteDate.new('1969-01-05').eql?( IncompleteDate.new('1969-01-05') )
      #  IncompleteDate.new('1969-01-05').eql?( Date.civil(1969, 1, 5) )
      #  IncompleteDate.new('1969-01').eql?( Date.civil(1969, 1)..Date.civil(1969, 1, 31) )
      #  IncompleteDate.new('1969-01').eql?( Date.civil(1969, 1)...Date.civil(1969, 2, 1) )
      #  
      # Please note that comparing an IncompleteDate with something else than a
      # IncompleteDate is normally not symmetric.
      def eql?(b)
        if b.kind_of? ::Range
          self.begin == b.begin && self.open_end == b.open_end
        else
          self.begin == b && self.open_end == b.succ
        end
      end
      alias :== :eql?
      
      # Returns true if b is completely included in this IncompleteDate. Unlike
      # CoreExtensions::Range::Equality#contains? include? allows equality for
      # begin and end.
      def include?(b)
        self.started_by?(b) || self.contains?(b) || self.eql?(b) || self.finished_by?(b)
      end
      
    end
    
  end    
end