require 'spec_helper'

describe Taperole::Commands::Installer do
  subject  { Taperole::Commands::Installer.new }

  describe '#docker_installed_precheck' do
    context 'when docker is installed' do
      before do
        allow(subject).to receive(:exec).and_return('Docker version 1.0.0').once
        allow_any_instance_of(Logger).to receive(:info)
      end

      it 'checks for docker' do
        expect(subject.docker_installed_precheck).to eq true
      end
    end

    context 'when docker is not installed' do
      let(:stubbed_logger) { double("logger", 'level=': nil, 'formatter=': nil) }

      before do
        allow(subject).to receive(:exec).and_return('no docker found').once
      end

      it 'returns false' do
        allow_any_instance_of(Logger).to receive(:info).twice
        expect(subject.docker_installed_precheck).to eq false
      end

      it 'informs the user' do
        expect_any_instance_of(Logger).to receive(:info).twice
        subject.docker_installed_precheck
      end
    end
  end

  describe '#docker_compose_installed_precheck' do
    context 'when docker compose is installed' do
      it 'returns true' do
        allow(subject).to receive(:exec).with('docker-compose version').and_return('docker-compose version 1.0.0, build abcdefg')
        expect(subject.docker_compose_installed_precheck).to eq true
      end
    end

    context 'when docker compose is not installed' do
      before do
        allow(subject).to receive(:exec).and_return('no docker found').once
      end

      it 'returns false' do
        allow_any_instance_of(Logger).to receive(:info).twice
        expect(subject.docker_compose_installed_precheck).to eq false
      end

      it 'informs the user' do
        expect_any_instance_of(Logger).to receive(:info).twice
        subject.docker_installed_precheck
      end
    end
  end
end
