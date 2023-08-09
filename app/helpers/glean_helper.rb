# frozen_string_literal: true

module GleanHelper
    require 'json'

    def produce_glean_log()
        Rails.logger.info {:hello => "goodbye"}.to_json
      end
end