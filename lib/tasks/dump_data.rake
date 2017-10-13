require_relative '../record_migrator'
require_relative '../user_dump'

namespace :db do

  desc "Dump pre-2.0 request and user data from the current enviroment's DB into JSON"
    task data_dump: :environment do
      Rails.application.eager_load!
      # first dump requests 
      [ ContractorRequest, StaffRequest, LaborRequest ]
        .each { |klass| klass.include(TwoPointOhMigrator) }
       
      File.open(Rails.root.join("tmp/requests.json") , 'w') do |file|
        file << ActiveRecord::Base.subclasses
          .select { |klass|  %w[ ContractorRequest LaborRequest StaffRequest ].include? klass.name }
          .map(&:all).map(&:to_a).flatten.map(&:to_v2).to_json
      end
      # now dump users   
      File.open(Rails.root.join("tmp/users.json") , 'w') { |file| file << User.dump }
    
    end

end
