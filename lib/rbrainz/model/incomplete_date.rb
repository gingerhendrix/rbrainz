# $Id$
# Copyright (c) 2007, Philipp Wolfer
# All rights reserved.
# See LICENSE for permissions.

require 'date'

module MusicBrainz
  module Model

    # Represents an incomplete date. An incomplete date is
    # a date which can be defined without day or without
    # month and day. It can be written as <em>YYYY</em>,
    # <em>YYYY-MM</em> or <em>YYYY-MM-DD</em>.
    class IncompleteDate
    
      attr_reader :year, :month, :day
      
      # Include the Comparable module to make incomplete dates
      # comparable and sortable.
      include Comparable
      
      # TODO: Validation of the date
      def initialize(date)
        @year = nil
        @month = nil
        @day = nil
        if date = date.to_s and date =~ /^\d{4}(-\d{2}){0,2}$/
          @year = date[0..3].to_i if date.size >= 4
          @month = date[5..6].to_i if date.size >= 7
          @day = date[8..9].to_i if date.size == 10
        elsif not date.empty?
          raise ArgumentError
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
      
      # Compare this incomplete date with another incomplete date.
      # If two incomplete dates are compared of which one date has
      # less information than the other only the information
      # present in both incomplete dates is used for comparison.
      # That means that the dates 1980-08-22, 1980-08 and 1980 are
      # all considered equal if compared to one another since it
      # can't be decided if e.g. the date 1980-08 is earlier or later
      # than 1980-08-22.
      # 
      # As a consequence of this a list of +IncompleteDate+ objects
      # won't get sorted in the lexical order of their string
      # representations. If you need a lexical order you must convert
      # these objects to strings before ordering them.
      def <=>(other)
        result = self.year <=> other.year
        if result == 0 and self.month and other.month
          result = self.month <=> other.month
          if result == 0 and self.day and other.day
            result = self.day <=> other.day
          end
        end
        return result
      end
     
    end
    
  end    
end