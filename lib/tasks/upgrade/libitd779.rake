# lib/tasks/temporary/sample_data.rake
namespace :upgrade do
  desc 'Perform database upgrade tasks needed for LIBITD-779'
  task libitd779: [:libitd779_upcase_employee_type] do
  end

  desc 'Upcase employee type codes'
  task libitd779_upcase_employee_type: :environment do
    ActiveRecord::Base.transaction do
      EmployeeType.all.each do |et|
          puts "Making #{et.code} into #{et.code.upcase}" 
          et.code = et.code.upcase
          et.save
      end
    end
  end
end
