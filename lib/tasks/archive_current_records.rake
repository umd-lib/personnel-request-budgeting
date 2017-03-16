# lib/tasks/archive_current_records.rake
namespace :db do
  desc 'Move records to archive tables'
  task :archive_current_records, [:fiscal_year] => :environment do |_t, args|
    fy  = args[:fiscal_year]
    abort "No fiscal year indicated." unless fy 
    
    %w( ContractorRequest StaffRequest LaborRequest ).each do |klass|
      puts " Moving #{klass.constantize.count} #{klass} records to the archive with FY #{ fy }." 
      klass.constantize.all.each do |record|
        archive_klass = "Archived#{klass}".constantize
        archive_klass.create!( record.attributes.slice(*archive_klass.attribute_names).merge( fiscal_year: fy ))
        record.delete 
      end
    end
  end
end
