require "bundler/gem_tasks"
task :default => [:test]

test_tasks = ['test:server']
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