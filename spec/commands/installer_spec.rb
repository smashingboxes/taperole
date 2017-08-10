require 'spec_helper'

describe Taperole::Commands::Installer do
  before(:each) do
    setup
    Taperole::Commands::Tape.new.invoke(described_class, command, [], options)
  end

  let(:setup) {}
  let(:options) { { vagrant: false, quiet: true } }

  let(:root) { Dir.entries(Dir.pwd) }
  let(:taperole) { Dir.entries("#{Dir.pwd}/taperole") }

  describe '#install' do
    let(:command) { :install }

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

      it 'creates provision.yml' do
        expect(taperole).to include('provision.yml')
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

      it 'creates provision.yml' do
        expect(taperole).to include('provision.yml')
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
      expect(taperole).to include('dev_keys')
    end
  end

  describe '#uninstall' do
    let(:setup) do
      Dir.mkdir("#{Dir.pwd}/taperole")
      FileUtils.touch("#{Dir.pwd}/taperole/provision.yml")
      FileUtils.touch("#{Dir.pwd}/taperole/deploy.yml")
      FileUtils.touch("#{Dir.pwd}/taperole/tape_vars.yml")
      FileUtils.touch("#{Dir.pwd}/taperole/rake.yml")
      FileUtils.touch("#{Dir.pwd}/taperole/roles")
      FileUtils.touch("#{Dir.pwd}/taperole/hosts")
      FileUtils.touch("#{Dir.pwd}/taperole/dev_keys")
      FileUtils.touch("#{Dir.pwd}/Vagrantfile")
    end
    let(:command) { :uninstall }

    it 'removes provision.yml' do
      expect(taperole).to_not include('provision.yml')
    end

    it 'removes deploy.yml' do
      expect(taperole).to_not include('deploy.yml')
    end

    it 'removes tape_vars.yml' do
      expect(taperole).to_not include('tape_vars.yml')
    end

    it 'removes rake.yml' do
      expect(taperole).to_not include('rake.yml')
    end

    it 'removes roles' do
      expect(taperole).to_not include('roles')
    end

    it 'removes hosts' do
      expect(taperole).to_not include('hosts')
    end

    it 'removes dev_keys' do
      expect(taperole).to_not include('dev_keys')
    end

    it 'removes Vagrantfile' do
      expect(root).to_not include('Vagrantfile')
    end
  end
end
