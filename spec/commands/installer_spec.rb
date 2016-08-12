require 'spec_helper'
require 'pry-byebug'

describe Taperole::Commands::Installer do
  describe '#install' do
    before(:each) do
      described_class.new([], args).install
    end

    let(:args) { { vagrant: false, silent: true } }

    it 'adds .tape to .gitignore' do
      expect(File.read('.gitignore')).to include('.tape')
    end

    it 'creates a taperoles directory' do
      expect(Dir.entries(Dir.pwd)).to include('taperole')
    end

    context 'in a rails app' do
      pending 'creates deploy.yml' do
      end

      pending 'creates omnibox.yml' do
      end

      pending 'creates tape_vars.yml' do
      end
    end

    context 'in a frontend app' do
      pending 'creates deploy.yml' do
      end

      pending 'creates omnibox.yml' do
      end

      pending 'creates tape_vars.yml' do
      end
    end

    pending 'creates the hosts file' do
    end

    pending 'creates the roles directory' do
    end

    pending 'creates the dev_keys directory' do
    end
  end
end
