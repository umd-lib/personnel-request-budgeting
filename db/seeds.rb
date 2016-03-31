# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

divisions = [{ code: 'ASD', name: 'Administrative Services' },
             { code: 'CSS', name: 'Collections Strategies & Services' },
             { code: 'DO', name: "Dean's Office" },
             { code: 'DSS', name: 'Digital Systems & Stewardship' },
             { code: 'PSD', name: 'Public Services' }]

divisions.each { |div| Division.create!(div) }

departments_by_division = {
  'ASD' => ['Budget & Business Services',
            'Libraries Facilities',
            'Libraries Human Resources'],
  'CSS' => ['Acquisitions',
            'Collections Development',
            'Metadata Services',
            'Prange',
            'Special Collections & University Archives'],
  'DO' => ['Communications', "Dean's Office"],
  'DSS' => ['Digitization',
            'Digital Data Services',
            'Digital Preservation Initiatives',
            'Software Support',
            'User Systems & Support'],
  'PSD' => ['Public Services', 'Research & Learning'] }

departments_by_division.each do |division_code, departments|
  division = Division.find_by_code(division_code)
  departments.each { |dept_name| division.departments.create!(name: dept_name) }
end
