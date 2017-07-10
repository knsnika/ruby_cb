# frozen_string_literal: true

module Codebreaker
  class User
    def initialize(name, hints, tries)
      self.name = name
      @hints = hints
      @tries = tries
    end

    def formatted
      format('%5s %4i', @name, points)
    end

    def points
      10 * @hints + 25 * @tries
    end

    private

    def name=(value)
      message = 'The name must be between 1 and 8 characters long'
      raise(ArgumentError, message) unless (1...8).cover? value.length
      @name = value
    end

  end
end
