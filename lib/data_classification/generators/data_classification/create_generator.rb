# frozen_string_literal: true

require "rails/generators"
require 'rails/generators/active_record/migration'
require 'rails/generators/base'

class CreateGenerator < Rails::Generators::Base
  include ActiveRecord::Generators::Migration
  include DataClassification::Migration

  namespace 'data_classification:create'
  source_root File.expand_path('../templates', __FILE__)

  # table1:column1:classification table2:column2:classification
  #   => ['table1:column1:classification', 'table2:column2:classification']
  argument :table_column_classification, type: :array

  def copy_migration
    validate!
    set_local_assigns!
    migration_template 'create_migration.rb.erb', "db/migrate/#{migration_file_name}.rb"
  end

  protected

  def set_local_assigns!
    @table_classifications = table_column_classification.map { |params| params.split(':') }.sort_by { |params| params[0] }
    tables = @table_classifications.map { |table, _column, _classification| table }.uniq.to_sentence.gsub(' ', '_')

    @migration_file_name = "create_data_classification_for_#{tables}"
    @migration_class_name = "CreateDataClassification#{tables.camelize}"
  end

  def validate!
    table_column_classification.each do |data|
      table, column, classification = data.split(':')

      if table.blank? || column.blank? || classification.blank?
        fail "All arguments require 3 parts <table>:<column>:<classification> referenced in '#{data}'"
      end
      unless ActiveRecord::Base.connection.table_exists?(table)
        fail "Table '#{table}' referenced in '#{data}' does not exist"
      end
      unless ActiveRecord::Base.connection.column_exists? table, column
        fail "Column '#{column}' on '#{table}' referenced in '#{data}' does not exist"
      end
      if DataClassification::DATA_CLASSIFICATIONS.map(&:to_s).exclude? classification
        fail "Data classification '#{classification}' referenced in '#{data}' is not valid, must be one of "\
          "#{DataClassification::DATA_CLASSIFICATIONS.join(', ')}"
      end
    end
  end
end
