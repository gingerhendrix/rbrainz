# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'rbrainz/model'
include MusicBrainz

class MyArtist < Model::Artist
end

class MyLabel < Model::Label
end

class MyRelease < Model::Release
end

class MyTrack < Model::Track
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

