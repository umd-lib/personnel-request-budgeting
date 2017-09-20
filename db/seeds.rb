# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

# Root
root =  Organization.create!( 
          { code: 'UMD', name: 'UMD Libraries',  organization_type: Organization.organization_types["root"] }
        )
divisions = [	
              { code: 'ASD', name: 'Administrative Services',  organization_type: Organization.organization_types["division"] },
             	{ code: 'CSS',  name: 'Collections Strategies & Services' , organization_type: Organization.organization_types["division"] },
             	{ code: 'DO', name: "Dean's Office",   organization_type: Organization.organization_types["division"] },
             	{ code: 'DSS',name: 'Digital Systems & Stewardship' ,  organization_type: Organization.organization_types["division"] },
							{ code: 'PSD', name: 'Public Services', organization_type: Organization.organization_types["division"] }
].map { |div|  Organization.create!(div.merge(parent: root)) }

# Departments
departments_by_division = {
  'ASD' => [{ code: 'BBS', name: 'Budget & Business Services', organization_type: Organization.organization_types["department"]  },
            { code: 'LF',name: 'Libraries Facilities', organization_type: Organization.organization_types["department"]  },
            { code: 'LHR', name: 'Libraries Human Resources' , organization_type: Organization.organization_types["department"]  }],
  'CSS' => [{ code: 'ACQ', name: "Acquisitions",  organization_type: Organization.organization_types["department"]  },
            { code: 'CD', name: "Collection", organization_type: Organization.organization_types["department"]  },
            { code: 'MDS', name: "Metadata Services", organization_type: Organization.organization_types["department"]  },
            { code: 'PRG', name: "Prange", organization_type: Organization.organization_types["department"]  },
            { code: 'SCUA', name: "Special Collections and University Archives",  organization_type: Organization.organization_types["department"] }],
  'DO' => [{ code: 'COM', name: "Communications", organization_type: Organization.organization_types["department"]  },
           { code: 'DO', name: "Dean's Office", organization_type: Organization.organization_types["department"]  }],
  'DSS' => [{ code: 'DCMR', name: "Digitization", organization_type: Organization.organization_types["department"]  },
            { code: 'DDS', name: "Digital Data Services", organization_type: Organization.organization_types["department"]  },
            { code: 'DPI', name: "Digital Preservation Initiatives", organization_type: Organization.organization_types["department"]  },
            { code: 'SSDR', name: "Software Systems Development and Research", organization_type: Organization.organization_types["department"]  },
            { code: 'USS', name: "User Systems & Support", organization_type: Organization.organization_types["department"]  }],
  'PSD' => [{ code: 'AS', name: "Access Services", organization_type: Organization.organization_types["department"]  },
            { code: 'LMS', name: "Library Media Services", organization_type: Organization.organization_types["department"]  },
            { code: 'PS', name: "Public Services", organization_type: Organization.organization_types["department"]  },
						{ code: 'RL', name: "Research & Learning", organization_type: Organization.organization_types["department"]  }]
}

departments = []
departments_by_division.each do |div, depts|
	d = divisions.find { |di| di[:code] === div }
	departments = depts.map { |dept| Organization.create!( dept.merge( parent: d ) ) }
end

units_by_department = {
  'AS' => [{ code: 'ILL', name: "Interlibrary Loan", organization_type: Organization.organization_types["unit"]   },
           { code: 'LN', name: "Late Night", organization_type: Organization.organization_types["unit"]  },
           { code: 'LSD', name: "Library Services Desk", organization_type: Organization.organization_types["unit"]  },
           { code: 'STK', name: "Stacks", organization_type: Organization.organization_types["unit"]  },
           { code: 'TLC', name: "Terapin Learning Commons", organization_type: Organization.organization_types["unit"]  }],
  'RL' => [{ code: 'ARCH', name: "Architecure Library",  organization_type: Organization.organization_types["unit"]  },
           { code: 'ART', name: "Ary Library", organization_type: Organization.organization_types["unit"]  },
           { code: 'EPSL', name: "Engineering & PS Library", organization_type: Organization.organization_types["unit"]  },
           { code: 'CHEM', name: "Chemistry Library", organization_type: Organization.organization_types["unit"]  },
           { code: 'HSSL',  name: "Humanities & Social Services", organization_type: Organization.organization_types["unit"] },
           { code: 'MSPAL', name: "Performing Arys Library", organization_type: Organization.organization_types["unit"] },
           { code: 'RC', name: "Research Commons", organization_type: Organization.organization_types["unit"]   },
           { code: 'RLL', name: "Research & Learning", organization_type: Organization.organization_types["unit"]  },
					 { code: 'TL', name: "Teaching & Learning", organization_type: Organization.organization_types["unit"]  }] 
}
units = []
units_by_department.each do |dept, us|
	d = departments.find { |de| de[:code] === dept }
  units = us.map { |u|  Organization.create!( u.merge( parent: d ) ) }
end

review_statuses = [{ code: 'UnderReview', name: 'Under Review', color: '#ffffff' },
                   { code: 'Approved', name: 'Approved', color: '#dcf5d0' },
                   { code: 'NotApproved', name: 'Not Approved', color: '#fa7073' },
                   { code: 'Contingent', name: 'Contingent', color: '#b3dffc' }]

review_statuses.each { |rs| ReviewStatus.create!(rs) }

[ [ 'Number Of Weeks Guide', "http://libi.lib.umd.edu/sites/default/files/FY18%20L&A%20Budget%20Calculations-Number%20of%20Weeks_0.pdf"] ,
  [ 'FY18 Budget Calendar', "http://libi.lib.umd.edu/sites/default/files/Budget%20Calendar%20FY18_1.pdf" ] ].each do |link|
  Link.create!( text: link.first, url: link.last )
end


