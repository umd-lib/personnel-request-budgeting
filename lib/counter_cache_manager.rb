# this resets the magic counter cache column
# setup to run after db:migrate and in tests
# after fixtures load
# rubocop:disable Metrics/AbcSize, Metrics/MethodLength
class CounterCacheManager
  class << self
    def run
      Rails.application.eager_load!

      # get all reflections
      ActiveRecord::Base.descendants.each do |klass|
        klass.reflections.each do |_name, ref|
          # find those using counter cache
          next unless ref.options[:counter_cache]
          # get reflection class
          one_klass = ref.class_name.constantize
          one_table, many_table = [one_klass, klass].map(&:table_name)
          # get all the ids for the cache
          ids = one_klass
                .joins(many_table.to_sym)
                .group("#{one_table}.id", "#{many_table}_count")
                .having("#{one_table}.#{many_table}_count != COUNT(#{many_table}.id)")
                .pluck("#{one_table}.id")
          # logger ||= Logger.new(STDOUT)
          # logger.info  "Resetting cache for #{one_klass} for #{klass} ( #{ids.length.to_s} records)"
          ids.each do |id|
            one_klass.reset_counters id, many_table
          end
        end
      end
    end
  end
end
