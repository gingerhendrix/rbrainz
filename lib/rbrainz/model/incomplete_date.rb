# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'date'

module MusicBrainz
  module Model

    # Represents an incomplete date. An incomplete date is
    # a date which can be defined without day or without
    # month and day. It can be written as <em>YYYY</em>,
    # <em>YYYY-MM</em> or <em>YYYY-MM-DD</em>.
    class IncompleteDate < ::Range
      attr_reader :year, :month, :day

      # TODO: Validation of the date
      def initialize(date)
        date = date.to_s if date.respond_to? :to_s
        if date =~ /^(\d{4})(?:-(\d{2})(?:-(\d{2}))?)?$/
          @year = $1.to_i
          @month = $2 ? $2.to_i : nil
          @day = $3 ? $3.to_i : nil
          if @month
            if @day
              start_d = Date.civil( @year, @month, @day)
              end_d = start_d.succ
            else
              start_d = Date.civil( @year, @month)
              end_d = Date.civil( @year, @month+1)
            end
          else
            start_d = Date.civil( @year)
            end_d = Date.civil( @year+1)
          end
          super( start_d, end_d, true)
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
    end
    
  end    
end