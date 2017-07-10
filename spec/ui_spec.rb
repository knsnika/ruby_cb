require 'spec_helper'

module Codebreaker
  RSpec.describe UI do
    subject(:app) { UI.new }

    it 'initialize game field' do
      expect(app.instance_variable_get(:@game)).to be_an_instance_of(Game)
    end

    describe '#run' do
      before do
        allow(app).to receive(:print)
        expect(app).to receive(:loop).and_yield
      end

      context 'when no' do
        it 'exits' do
          expect(app).to receive(:gets).and_return('break')
          app.run
        end
      end

      context 'when yes' do
        it 'calls #play' do
          expect(app).to receive(:gets).and_return('play')
          app.run
        end
      end

      context 'when watch' do
        it 'calls #high_scores' do
          expect(app).to receive(:gets).and_return('high_scores')
          app.run
        end
      end

      context 'when else' do
        it 'outputs message about wrong option' do
          expect(app).to receive(:gets).and_return('else')
          app.run
        end
      end
    end

    describe '#save_score' do
      context 'when no' do
        it "doesn't call #save_score of @game" do
          allow(app).to receive(:print)
          allow(app).to receive_message_chain(:gets, :chomp).and_return('no')
          expect(app.instance_variable_get(:@game)).not_to receive(:save_score)
          app.send(:save_score)
        end
      end

      context 'when y' do
        it 'calls #save_score of @game' do
          allow(app).to receive(:print)
          allow(app).to receive(:puts)
          allow(app).to receive(:gets).and_return('y', 'Name')
          expect(app.instance_variable_get(:@game)).to receive(:save_score)
          app.send(:save_score)
        end
      end
    end

    describe '#high_scores' do
      context 'when scores empty' do
        it "returns 'No scores'" do
          expect(app.instance_variable_get(:@game)).to receive(:high_scores).and_return([])
          expect(app.send(:high_scores)).to eq('No scores')
        end
      end
    end

    describe '#play' do
      before do
        allow(app).to receive(:play)
      end

      context 'when y' do
        it 'ends the game' do
          expect(app).not_to receive(:save_score)
          app.send(:play)
        end
      end

    end
  end
end
