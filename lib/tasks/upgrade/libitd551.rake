# lib/tasks/temporary/sample_data.rake
namespace :upgrade do
  desc 'Perform database upgrade tasks needed for LIBITD-551'
  task libitd551: [:libitd551_change_department_name] do
  end

  desc 'change "Collections Development" to "Collection'
  task libitd551_change_department_name: :environment do
    old_to_new_names = {
      'Collections Development' => 'Collection'
    }

    puts 'Changing department names:'
    ActiveRecord::Base.transaction do
      old_to_new_names.each do |old_name, new_name|
        print "  #{old_name} --> #{new_name}"
        dept = Department.find_by_name(old_name)
        if dept
          dept.name = new_name
          dept.save!
          puts ' -- Done'
        else
          puts ' -- Not Found'
        end
      end
    end
  end
end
