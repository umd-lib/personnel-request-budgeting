# lib/tasks/temporary/sample_data.rake
namespace :upgrade do
  desc 'Perform database upgrade tasks needed for LIBITD-551'
  task libitd531: :environment do
    old_to_new_codes = {
      "ContFac" => "CFAC",
      "Ex" => "EX",
      "Fac" => "FAC",
      "FAC-Hrly" => "FHRLY",
      "Nex" => "NEX",
      "Student" => "STUD"
    } 

    puts 'Changing department names:'
    ActiveRecord::Base.transaction do
      old_to_new_codes.each do |old_code, new_code|
        e = EmployeeType.find_by_code(old_code)
        next unless e 
        print "  #{old_code} --> #{new_code}"
        e.code = new_code
        e.save
      end
    end
  end

end
