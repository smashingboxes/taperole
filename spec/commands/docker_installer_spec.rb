require 'spec_helper'

describe Taperole::Commands::Installer do
  describe '#docker_installed_precheck' do
    subject  { Taperole::DockerInstaller.new }

    it 'checks for docker' do
      expect(subject.docker_installed_precheck).to eq true
    end
  end
end
