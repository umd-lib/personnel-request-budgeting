# frozen_string_literal: true

# A place for the class methods added to the request modle ( because the cop
# doesn't like the length of the class :/ )
module Requestable
  extend ActiveSupport::Concern
  # rubocop:disable Metrics/BlockLength
  class_methods do
    def policy_class
      RequestPolicy
    end

    # returns just the source_class for Archived records
    def source_class
      name.remove(/^Archived/).constantize
    end

    def human_name
      'Requests'
    end

    # all the fields associated to the model
    def fields
      %i[ request_model_type position_title employee_type request_type
          contractor_name employee_name
          nonop_source justification organization__name unit__name
          review_status__name review_comment user__name created_at updated_at ]
    end

    # Returns an ordered array used in the index pages
    def index_fields
      fields - %i[nonop_source justification review_comment created_at updated_at]
    end

    def current_table_name
      current_table = current_scope.arel.source.left

      case current_table
      when Arel::Table
        current_table.name
      when Arel::Nodes::TableAlias
        current_table.right
      else
        raise
      end
    end
  end
end
