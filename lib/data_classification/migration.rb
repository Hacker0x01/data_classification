# frozen_string_literal: true

module DataClassification
  module Migration
    def add_data_classification(table, column, classification)
      change_column_comment table, column, data_classification_comment(classification)
    end

    def data_classification_comment(classification)
      fail "This is not a valid data classification" unless DATA_CLASSIFICATIONS.include? classification

      {
        tags: [
          "classification:#{classification}",
        ],
      }.to_json
    end
  end
end
