# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'rbrainz/webservice/webservice'

class MockWebservice < MusicBrainz::Webservice::IWebservice
  
  DATA_PATH = 'test/test-data/'
  
  def get(entity_type, options = {:id => nil, :include => nil, :filter => nil, :version => 1})
    case entity_type
    when :artist
      if options[:id]
        case options[:id]
        when '00000000-0000-0000-0000-000000000000'
          file = 'invalid/artist/basic_1.xml'
        when '11111111-1111-1111-1111-111111111111'
          file = 'valid/artist/empty_1.xml'
        else
          file = 'valid/artist/Tori_Amos_1.xml'
        end
      else
        file = 'valid/artist/search_result_1.xml'
      end
    when :release
      if options[:id]
        file = 'valid/release/Under_the_Pink_1.xml'
      else
        file = 'valid/release/search_result_1.xml'
      end
    when :track
      if options[:id]
        file = 'valid/track/Silent_All_These_Years_1.xml'
      else
        file = 'valid/track/search_result_1.xml'
      end
    when :label
      if options[:id]
        file = 'valid/label/Atlantic_Records_1.xml'
      else
        file = 'valid/label/search_result_1.xml'
      end
    when :user
      file = 'valid/user/User_1.xml'
    end
    return File.read(DATA_PATH + file)
  end

end