require 'rspec'
require 'taperole'
require 'fileutils'

starting_directory = Dir.pwd
tape_testing_dir = '/tmp/tape-testing'

RSpec.configure do |config|
  config.before(:suite) do
    Dir.mkdir(tape_testing_dir)
    Dir.chdir(tape_testing_dir)
  end

  config.before(:each) do
    FileUtils.rm_rf(Dir.glob("#{tape_testing_dir}/*"))
    FileUtils.touch("#{tape_testing_dir}/.gitignore")
    Dir.chdir(tape_testing_dir)
  end

  config.after(:suite) do
    Dir.chdir(starting_directory)
    FileUtils.rm_rf(tape_testing_dir)
  end
end
