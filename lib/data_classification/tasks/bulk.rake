# frozen_string_literal: true

require 'data_classification/migration'

namespace :data_classification do
  include DataClassification

  desc 'Classify your table/columns in bulk'
  task bulk_classify: :environment do
    classifications = []
    unclassified = []

    ActiveRecord::Base.connection.tables.each do |table_name|
      ActiveRecord::Base.connection.columns(table_name).each do |column|
        next if column.comment.present?
        unclassified << [table_name, column.name]
      end
    end

    unclassified.each do |table_name, column_name|
      puts "Table: #{table_name}, Column: #{column_name}"
      puts "Data classification (#{DATA_CLASSIFICATIONS.join(',')}, q(uit), n(ext) >"
      selection = STDIN.gets.chomp
      if selection == 'q'
        break
      elsif selection == 'n'
        next
      elsif DATA_CLASSIFICATIONS.map(&:to_s).include? selection
        classifications << [table_name, column_name, selection]
      else
        puts 'Invalid option, try again.'
        redo
      end
    end

    if classifications.any?
      arguments = classifications.map { |classification| classification.join(':') }
      Rails::Generators.invoke 'data_classification:create', arguments
    else
      puts 'No classifications made'
    end
  end

  task list: :environment do
    ActiveRecord::Base.connection.tables.each do |table_name|
      ActiveRecord::Base.connection.columns(table_name).each do |column|
        next if column.comment.nil?
        data_classification = JSON.parse(column.comment)

        puts [table_name, column.name, data_classification['tags']].join(',')
      end
    end
  end
end
