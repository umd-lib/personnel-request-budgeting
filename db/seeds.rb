# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

division_names = [
  'Administrative Services', 'Collections Strategies & Services',
  "Dean's Office", 'Digital Systems & Stewardship', 'Public Services' ]

division_names.each { |name| Division.create!(name: name) }

departments_by_division = {
  'Administrative Services' => [ 'Budget & Business Services',
                                 'Libraries Facilities',
                                 'Libraries Human Resources' ],
  'Collections Strategies & Services' => [ 'Acquisitions',
                                           'Collections Development',
                                           'Metadata Services',
                                           'Prange',
                                           'Special Collections & University Archives' ],
  "Dean's Office" => [ 'Communications', "Dean's Office" ],
  'Digital Systems & Stewardship' => [ 'Digitization',
                                       'Digital Data Services',
                                       'Digital Preservation Initiatives',
                                       'Software Support',
                                       'User Systems & Support' ],
  'Public Services' => [ 'Public Services', 'Research & Learning' ] }

departments_by_division.each do |division_name, departments|
  division = Division.find_by_name(division_name)
  departments.each { |dept_name| division.departments.create!(name: dept_name) }
end



