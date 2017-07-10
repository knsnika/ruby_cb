# frozen_string_literal: true

require 'yaml'

module Codebreaker
  module Saver
    private

    FILE_NAME = 'scores.yml'.freeze

    def write(user)
      scores = info_file
      scores << user
      File.open(FILE_NAME, 'w') { |f| f.write scores.to_yaml }
    end

    def info_file
      return [] if !File.exist?(FILE_NAME) || File.zero?(FILE_NAME)
      YAML.load_file(FILE_NAME)
    end
  end
end