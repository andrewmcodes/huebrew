# frozen_string_literal: true

require_relative "../command"

module Huebrew
  module CLI
    module Commands
      # Display version information
      class Version < Command
        desc "Display version information"

        def call(**)
          puts "huebrew version #{Huebrew::VERSION}"
        end
      end
    end
  end
end
