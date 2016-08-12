require 'spec_helper'
require 'pry-byebug'

describe Taperole::Commands::Installer do
  describe '#install' do
    before(:each) do
      setup
      Taperole::Commands::Tape.new.invoke(described_class, :install, [], options)
    end
    let(:setup) {}

    let(:root) { Dir.entries(Dir.pwd) }
    let(:taperole) { Dir.entries("#{Dir.pwd}/taperole") }

    let(:options) { { vagrant: false, quiet: true } }

    it 'adds .tape to .gitignore' do
      expect(File.read('.gitignore')).to include('.tape')
    end

    it 'creates a taperoles directory' do
      expect(root).to include('taperole')
    end

    context 'in a rails app' do
      let(:setup) { FileUtils.touch('config.ru') }

      it 'creates deploy.yml' do
        expect(taperole).to include('deploy.yml')
      end

      it 'creates omnibox.yml' do
        expect(taperole).to include('omnibox.yml')
      end

      it 'creates tape_vars.yml' do
        expect(taperole).to include('tape_vars.yml')
      end
    end

    context 'in a frontend app' do
      let(:setup) { FileUtils.touch('package.json') }

      it 'creates deploy.yml' do
        expect(taperole).to include('deploy.yml')
      end

      it 'creates omnibox.yml' do
        expect(taperole).to include('omnibox.yml')
      end

      it 'creates tape_vars.yml' do
        expect(taperole).to include('tape_vars.yml')
      end
    end

    it 'creates the hosts file' do
      expect(taperole).to include('hosts')
    end

    it 'creates the roles directory' do
      expect(taperole).to include('roles')
    end

    it 'creates the dev_keys directory' do
      expect(root).to include('dev_keys')
    end
  end
end
