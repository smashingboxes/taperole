require 'rspec'
require 'taperole'
require 'fileutils'

starting_directory = Dir.pwd

RSpec.configure do |config|
  config.before(:suite) do
    Dir.mkdir('/tmp/tape-testing')
    Dir.chdir('/tmp/tape-testing')
    FileUtils.touch('.gitignore')
  end

  config.after(:suite) do
    Dir.chdir(starting_directory)
    FileUtils.rm_rf('/tmp/tape-testing')
  end
end
