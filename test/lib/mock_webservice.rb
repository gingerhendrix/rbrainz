# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'rbrainz/webservice/webservice'

class MockWebservice < MusicBrainz::Webservice::IWebservice
  
  DATA_PATH = 'test/test-data/valid/'
  
  def get(entity_type, options = {:id => nil, :include => nil, :filter => nil, :version => 1})
    case entity_type
    when :artist
      if options[:id]
        file = 'artist/Tori_Amos_1.xml'
      else
        file = 'artist/search_result_1.xml'
      end
    when :release
      if options[:id]
        file = 'release/Under_the_Pink_1.xml'
      else
        file = 'release/search_result_1.xml'
      end
    when :track
      if options[:id]
        file = 'track/Silent_All_These_Years_1.xml'
      else
        file = 'track/search_result_1.xml'
      end
    when :label
      if options[:id]
        file = 'label/Atlantic_Records_1.xml'
      else
        file = 'label/search_result_1.xml'
      end
    when :user
      file = 'user/User_1.xml'
    end
    return File.read(DATA_PATH + file)
  end

end