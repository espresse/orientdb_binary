require "bundler/gem_tasks"
task :default => [:test]


task :build do
  system "gem build orientdb-binary.gemspec"
end

task :release => :build do
  system "gem push orientdb-binary-#{OrientdbBinary::VERSION}"
end

task :install do
  system "gem install orientdb-binary-#{OrientdbBinary::Version}"
end

test_tasks = ['test:all']
desc "Run all tests"
task :test => test_tasks

namespace :test do
  desc "Run server tests"
  task :server do
    $: << 'lib'

    $LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))
    require_relative 'lib/orientdb_binary'
    require 'test/test_helper'

    Dir['./test/server/**/test_*.rb'].each { |test| require test }
  end
end

namespace :test do
  desc "Run database tests"
  task :database do
    $: << 'lib'

    $LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))
    require_relative 'lib/orientdb_binary'
    require 'test/test_helper'

    Dir['./test/database/**/test_*.rb'].each { |test| require test }
  end
end

namespace :test do
  desc "Run all tests and check coverage"
  task :all do
    $: << 'lib'
    require 'simplecov'

    SimpleCov.start do
      add_filter "test"
      command_name 'Mintest'
    end

    $LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))
    require_relative 'lib/orientdb_binary'
    require 'test/test_helper'

    Dir['./test/**/test_*.rb'].each { |test| require test }
  end
end
