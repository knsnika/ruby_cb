# frozen_string_literal: true

require_relative 'user'
require_relative 'saver'

module Codebreaker
  class Game
    include Saver

    attr_reader :tries, :hints

    TRIES = 10
    HINTS = 3

    def start
      @secret_code = 4.times.map{rand(1..6)}.join
      @result      = ''
      @hints       = HINTS
      @tries       = TRIES
      @indexes_hint = (0...4).to_a
    end

    def check_it(input)
      tested input
      @tries -= 1
      @result = input_check(@secret_code.chars, input.chars)
    end

    def hint
      return false if @hints.zero?
      @tries -= 1
      @hints -= 1
      hints_generate
    end

    def finished?
      @tries.zero? || result
    end

    def result
      @result == '++++'
    end

    def answer
      @secret_code if finished?
    end

    def save_score(name)
      write User.new(name, @hints, @tries)
    end

    def high_scores
      info_file
    end

    private

    def input_check(code_chars, input_chars)
      pluses = 4.times.count { |i| code_chars[i] == input_chars[i] }

      input_chars.each do |char|
        next unless code_chars.include? char
        code_chars.delete_at(code_chars.index(char))
      end

      minuses = 4 - pluses - code_chars.size

      ('+' * pluses) + ('-' * minuses)
    end

    def hints_generate
      hint = '_' * 4
      index = @indexes_hint.delete(@indexes_hint.sample)
      hint[index] = @secret_code[index]
      hint
    end

    def tested(input)
      regexp = Regexp.new("^[1-6]{4}$")
      message = "Secret code must consist of 4 digits from 1 to 6"
      raise(ArgumentError, message) if !input.match?(regexp)
    end
  end
end
