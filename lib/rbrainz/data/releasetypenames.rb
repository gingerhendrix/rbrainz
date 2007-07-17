# $Id$
#
# Author::    Philipp Wolfer (mailto:phw@rubyforge.org)
# Copyright:: Copyright (c) 2007, Nigel Graham, Philipp Wolfer
# License::   RBrainz is free software distributed under a BSD style license.
#             See LICENSE[file:../LICENSE.html] for permissions.

require 'rbrainz/model/release'

module MusicBrainz
  module Data
  
    # See Utils#get_release_type_name
    RELEASE_TYPE_NAMES = {
    	Model::Release::TYPE_ALBUM          => 'Album',
    	Model::Release::TYPE_AUDIOBOOK      => 'Audiobook',
    	Model::Release::TYPE_BOOTLEG        => 'Bootleg',
    	Model::Release::TYPE_COMPILATION    => 'Compilation',
        Model::Release::TYPE_EP             => 'EP',
        Model::Release::TYPE_INTERVIEW      => 'Interview',
        Model::Release::TYPE_LIVE           => 'Live',
        Model::Release::TYPE_NONE           => 'None',
        Model::Release::TYPE_OFFICIAL       => 'Official',
        Model::Release::TYPE_OTHER          => 'Other',
        Model::Release::TYPE_PROMOTION      => 'Promotion',
        Model::Release::TYPE_PSEUDO_RELEASE => 'Pseudo-Release',
        Model::Release::TYPE_REMIX          => 'Remix',
        Model::Release::TYPE_SINGLE         => 'Single', 
        Model::Release::TYPE_SOUNDTRACK     => 'Soundtrack',
        Model::Release::TYPE_SPOKENWORD     => 'Spokenword'
    }

  end
end