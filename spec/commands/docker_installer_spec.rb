require 'spec_helper'

describe Taperole::Commands::Installer do

  describe '#docker_installed_precheck' do
    context 'when docker is installed' do
      subject  { Taperole::DockerInstaller.new }

      it 'checks for docker' do
        expect(subject.docker_installed_precheck).to eq true
      end
    end

    context 'when docker is not installed' do
      let(:stubbed_logger) { double("logger", 'level=': nil, 'formatter=': nil) }
      let(:installer) { Taperole::DockerInstaller.new }

      before do
        allow(installer).to receive(:exec).and_return('no docker found').once
      end

      it 'informs the user' do
        expect_any_instance_of(Logger).to receive(:info).twice
        installer.docker_installed_precheck
      end
    end
  end
end
