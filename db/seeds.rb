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
  'ASD' => [{ code: 'BBS', name: 'Budget & Business Services' },
            { code: 'LF', name: 'Libraries Facilities' },
            { code: 'LHR', name: 'Libraries Human Resources' }],
  'CSS' => [{ code: 'ACQ', name: 'Acquisitions' },
            { code: 'CD', name: 'Collections Development' },
            { code: 'MDS', name: 'Metadata Services' },
            { code: 'PRG', name: 'Prange' },
            { code: 'SCUA', name: 'Special Collections & University Archives' }],
  'DO' => [{ code: 'COM', name: 'Communications' },
           { code: 'DO', name: "Dean's Office" }],
  'DSS' => [{ code: 'DCMR', name: 'Digitization' },
            { code: 'DDS', name: 'Digital Data Services' },
            { code: 'DPI', name: 'Digital Preservation Initiatives' },
            { code: 'SSDR', name: 'Software Support' },
            { code: 'USS', name: 'User Systems & Support' }],
  'PSD' => [{ code: 'PS', name: 'Public Services' },
            { code: 'RL', name: 'Research & Learning' }] }

departments_by_division.each do |division_code, departments|
  division = Division.find_by_code(division_code)
  departments.each do |dept|
    division.departments.create!(dept)
  end
end
