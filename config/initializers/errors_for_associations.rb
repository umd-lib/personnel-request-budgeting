# Make sure errors on associations are also set on the _id and _ids fields
# From: http://iada.nl/blog/article/rails-tip-display-association-validation-errors-fields
module ActionView
  module Helpers
    # Patching ActiveModelInstanceTag to show errors on fields that have
    # associations such as "select" drop-downs
    module ActiveModelInstanceTag
      def error_message_with_associations
        association = many_associations || foreign_key_association
        if association
          object.errors[association.name] + error_message_without_associations
        else
          error_message_without_associations
        end
      end
      alias_method_chain :error_message, :associations

      private

        # Returns an AssociationReflection, or nil
        def many_associations
          return unless @method_name.end_with?('_ids')
          association_name = @method_name.chomp('_ids').pluralize.to_sym
          object.class.reflect_on_association(association_name)
        end

        # Returns an association if a foreign key match is found, or nil
        def foreign_key_association
          object.class.reflect_on_all_associations.find do |a|
            a.macro == :belongs_to && a.foreign_key == @method_name
          end
        end
    end
  end
end
