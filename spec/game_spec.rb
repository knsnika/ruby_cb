require 'spec_helper'

module Codebreaker
  RSpec.describe Game do
    subject(:game) { Game.new }
    before { game.start }

    it { is_expected.to respond_to(:tries) }

    it { is_expected.not_to respond_to(:tries=) }

    describe '#start' do
      it 'saves secret code' do
        game.start
        expect(game.instance_variable_get(:@secret_code)).not_to be_empty
      end

      it 'saves secret code with numbers from 1 to 6' do
        game.start
        expect(game.instance_variable_get(:@secret_code)).to match(/[1-6]+/)
      end

      it 'generates a different secret code each time' do
        sec_code1 = game.instance_variable_get(:@secret_code)
        game.start
        sec_code2 = game.instance_variable_get(:@secret_code)
        expect(sec_code1).not_to eq(sec_code2)
      end
    end

     describe '#check_it' do

      it 'returns results' do
        game.instance_variable_set(:@secret_code, '2131')

        test_data    = %w[1111 2222 3333 4444 5555 6666
                          1312 1216 1616 1666 1234 2131]
        expectations = ['++', '+', '+', '', '', '',
                        '----', '---', '--', '-', '+--', '++++']

        test_data.each_index do |i|
          expect(game.check_it(test_data[i])).to eq(expectations[i])
        end
      end

      it 'uses check_guess method' do
        secret_code = game.instance_variable_get(:@secret_code)
        input = '1111'
        expect(game).to receive(:input_check).with(secret_code.chars, input.chars)
        game.check_it(input)
      end
     end

    describe '#info_file' do
      let(:file_data) { game.send(:info_file) }
      after { File.delete('scores.yml') if File.exist?('scores.yml') }

      it 'returns empty array if file empty' do
        File.open('scores.yml', 'w') {}
        expect(file_data).to be_an_instance_of(Array)
        expect(file_data).to be_empty
      end

    describe '#high_scores' do
      it 'uses #info_file' do
        expect(game).to receive(:info_file)
        game.high_scores
      end
    end
  end
end
end
