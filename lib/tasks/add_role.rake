# lib/tasks/add_role.rake
namespace :db do
  desc 'Add a role'
  task :add_role, [:cas_directory_id, :role_type_code, :org_code] => :environment do |_t, args|
    cas_directory_id = args[:cas_directory_id]
    user = User.find_by_cas_directory_id(cas_directory_id)
    unless user
      puts "User '#{cas_directory_id}' not recognized."
      next # 'next' in a Rake task acts like return
    end

    role_type_code = args[:role_type_code]
    role_type = RoleType.find_by_code(role_type_code)
    unless role_type
      puts "Role type code '#{role_type_code}' not recognized."
      next # 'next' in a Rake task acts like return
    end

    if role_type_code == 'admin'
      begin
        Role.create!(user_id: user.id, role_type_id: role_type.id)
        puts "'Added Admin role for #{cas_directory_id}'"
      rescue ActiveRecord::RecordInvalid => e
        puts e.message
      end
      next
    end

    org_code = args[:org_code]
    if role_type_code == 'division'
      org = Division.find_by_code(org_code)
    elsif role_type_code == 'department'
      org = Department.find_by_code(org_code)
    elsif role_type_code == 'unit'
      org = Unit.find_by_code(org_code)
    end

    unless org
      puts "Organization code '#{org_code}' not recognized for '#{role_type_code}' role."
      next # 'next' in a Rake task acts like return
    end

    begin
      if role_type_code == 'division'
        Role.create!(user_id: user.id, role_type_id: role_type.id, division_id: org.id)
        puts "'Added role for #{cas_directory_id}' with Division '#{org_code}'"
      elsif role_type_code == 'department'
        Role.create!(user_id: user.id, role_type_id: role_type.id, department_id: org.id)
        puts "'Added role for #{cas_directory_id}' with Department '#{org_code}'"
      elsif role_type_code == 'unit'
        Role.create!(user_id: user.id, role_type_id: role_type.id, unit_id: org.id)
        puts "'Added role for #{cas_directory_id}' with Unit '#{org_code}'"
      end
    rescue ActiveRecord::RecordInvalid => e
      puts e.message
    end
  end
end
