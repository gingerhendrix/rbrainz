# $Id$
# Copyright (c) 2007, Philipp Wolfer
# All rights reserved.
# See LICENSE for permissions.
 
# Rakefile for RBrainz

require 'rubygems'
require 'rake/gempackagetask'
require 'rake/testtask'
require 'rake/rdoctask'

task :default do
  puts "Please see 'rake --tasks' for an overview of the available tasks."
end

# Packaging tasks: -------------------------------------------------------

PKG_NAME = 'rbrainz'
PKG_VERSION = '0.2.0'
PKG_FILES = FileList[
  "Rakefile", "LICENSE", "README", "TODO", "CHANGES",
  "doc/README.rdoc",
  "examples/**/*.rb",
  "lib/**/*.rb",
  "test/**/*.rb",
  "test/test-data/**/*"
]
PKG_EXTRA_RDOC_FILES = ['doc/README.rdoc', 'LICENSE', 'TODO', 'CHANGES']

spec = Gem::Specification.new do |spec|
  spec.platform = Gem::Platform::RUBY
  spec.summary = 'Ruby library for the MusicBrainz XML webservice.'
  spec.name = PKG_NAME
  spec.version = PKG_VERSION
  spec.requirements << 'Optional: mb-discid >= 0.1.2 (for calculating disc IDs)'
  spec.autorequire = spec.name
  spec.files = PKG_FILES
  spec.description = <<EOF
    RBrainz is a Ruby client library to access the MusicBrainz XML
    webservice. RBrainz supports the MusicBrainz XML Metadata Version 1.2,
    including support for labels and extended release events.
    
    RBrainz follows the design of python-musicbrainz2, the reference
    implementation for a MusicBrainz client library. Developers used to
    python-musicbrainz2 should already know most of RBrainz' interface.
    However, RBrainz differs from python-musicbrainz2 wherever it makes
    the library more Ruby like or easier to use.
EOF
  spec.author = ['Philipp Wolfer', 'Nigel Graham']
  spec.email = 'phw@rubyforge.org'
  spec.homepage = 'http://rbrainz.rubyforge.org'
  spec.rubyforge_project = 'rbrainz'
  spec.has_rdoc = true
  spec.extra_rdoc_files = PKG_EXTRA_RDOC_FILES
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar_gz= true
end

# Build the RBrainz gem and install it"
task :install => [:test, :gem] do
  sh %{gem install pkg/#{PKG_NAME}-#{PKG_VERSION}.gem}
end

# Uninstall RBrainz"
task :uninstall => [:gem] do
  sh %{gem uninstall #{PKG_NAME}}
end

# Test tasks: ------------------------------------------------------------

desc "Run the unit and functional tests"
task :test => [:test_units, :test_functional]

desc "Run just the unit tests"
Rake::TestTask.new(:test_units) do |test|
  test.test_files = FileList['test/test*.rb']
  test.libs = ['lib', 'test/lib']
  test.warning = true
end

desc "Run just the functional tests"
Rake::TestTask.new(:test_functional) do |test|
  test.test_files = FileList['test/functional*.rb']
  test.libs = ['lib', 'test/lib']
  test.warning = true
end

# Documentation tasks: ---------------------------------------------------

Rake::RDocTask.new do |rdoc|
  rdoc.title    = "RBrainz %s" % PKG_VERSION
  rdoc.main     = 'doc/README.rdoc'
  rdoc.rdoc_dir = 'doc/api'
  rdoc.rdoc_files.include('lib/**/*.rb', PKG_EXTRA_RDOC_FILES)
  rdoc.options << '--inline-source' << '--line-numbers' #<< '--diagram'
end

# Other tasks: -----------------------------------------------------------

def egrep(pattern)
  Dir['**/*.rb'].each do |fn|
    count = 0
    open(fn) do |f|
      while line = f.gets
	count += 1
	if line =~ pattern
	  puts "#{fn}:#{count}:#{line}"
	end
      end
    end
  end
end

desc "Look for TODO and FIXME tags in the code"
task :todo do
  egrep(/#.*(FIXME|TODO)/)
end
