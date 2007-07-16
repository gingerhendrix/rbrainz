# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

class MyArtist < Model::Artist
  def self.entity_type
    :artist
  end
end

class MyLabel < Model::Label
  def self.entity_type
    :label
  end
end

class MyRelease < Model::Release
  def self.entity_type
    :release
  end
end

class MyTrack < Model::Track
  def self.entity_type
    :track
  end
end

class MyAlias < Model::Alias
end

# An alternative model factory for testing purposes.
class MyFactory < Model::DefaultFactory 

  def new_artist
    MyArtist.new
  end

  def new_label
    MyLabel.new
  end

  def new_release
    MyRelease.new
  end

  def new_track
    MyTrack.new
  end

  def new_alias
    MyAlias.new
  end

end

