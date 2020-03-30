require "data_classification/version"
require "data_classification/migration"
require "data_classification/generators/data_classification/create_generator"

module DataClassification
  require 'data_classification/railtie' if defined?(Rails)
  class Error < StandardError; end

  DATA_CLASSIFICATIONS = [
    PUBLIC = :public,
    OPERATIONAL = :operational,
    CRITICAL = :critical,
    CONFIDENTIAL = :confidential,
    PERSONAL = :personal,
    PERSONAL_SENSITIVE = :personal_sensitive,
  ].freeze
end
