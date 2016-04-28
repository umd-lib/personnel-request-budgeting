# As suggested in http://schock.net/articles/2015/01/21/modules-with-rails-tests-share-behavior-minitest/

# Test for sorted "Department" dropdown entries
module DepartmentDropdownTest
  extend ActiveSupport::Concern

  included do
    test 'department dropdown field should be sorted' do
      sorted_department_names = Department.order('name').collect(&:name)

      # Prepend dropdown prompt
      sorted_department_names.unshift('Select Department')

      assert_select 'select[id=?] option', "#{@field_prefix}_department_id" do |opts|
        opts.each do |opt|
          assert_equal sorted_department_names.shift, opt.text
        end
      end
    end
  end
end

# Test for sorted "Unit" dropdown entries
module UnitDropdownTest
  extend ActiveSupport::Concern
  included do
    test 'unit dropdown field should be sorted' do
      sorted_unit_names = Unit.order('name').collect(&:name)

      # Prepend dropdown prompt
      sorted_unit_names.unshift('Select Unit')

      assert_select 'select[id=?] option', "#{@field_prefix}_unit_id" do |opts|
        opts.each do |opt|
          assert_equal sorted_unit_names.shift, opt.text
        end
      end
    end
  end
end

# Test for sorted "Employee Category" dropdown entries
module EmployeeCategoryDropdownTest
  extend ActiveSupport::Concern
  included do
    test 'employee category dropdown field should be sorted' do
      sorted_employee_category_names = EmployeeCategory.order('name').collect(&:name)

      # Prepend dropdown prompt
      sorted_employee_category_names.unshift('Select Category')

      assert_select 'select[id=?] option', "#{@field_prefix}_employee_category_id" do |opts|
        opts.each do |opt|
          assert_equal sorted_employee_category_names.shift, opt.text
        end
      end
    end
  end
end

# Test for sorted "Employee Type" dropdown entries
module EmployeeTypeDropdownTest
  extend ActiveSupport::Concern
  included do
    test 'employee type dropdown field should be sorted' do
      sorted_employee_type_names = EmployeeType.employee_types_with_category(@valid_category_code)
                                               .order('name').collect(&:name)

      # Prepend dropdown prompt
      sorted_employee_type_names.unshift('Select Employee Type')

      assert_select 'select[id=?] option', "#{@field_prefix}_employee_type_id" do |opts|
        opts.each do |opt|
          assert_equal sorted_employee_type_names.shift, opt.text
        end
      end
    end
  end
end

# Test for sorted "Request Type" dropdown entries
module RequestTypeDropdownTest
  extend ActiveSupport::Concern
  included do
    test 'request type dropdown field should be sorted' do
      sorted_request_type_names = RequestType.order('name')
                                             .select { |a| @valid_request_type_codes.include?(a.code) }
                                             .collect(&:name)

      # Prepend dropdown prompt
      sorted_request_type_names.unshift('Select Request Type')

      assert_select 'select[id=?] option', "#{@field_prefix}_request_type_id" do |opts|
        opts.each do |opt|
          assert_equal sorted_request_type_names.shift, opt.text
        end
      end
    end
  end
end

# Test for sorted "Division" dropdown entries
module DivisionDropdownTest
  extend ActiveSupport::Concern
  included do
    test 'division dropdown field should be sorted' do
      sorted_request_type_names = Division.order('name').collect(&:name)

      # Prepend dropdown prompt
      sorted_request_type_names.unshift('Select Division')

      assert_select 'select[id=?] option', "#{@field_prefix}_division_id" do |opts|
        opts.each do |opt|
          assert_equal sorted_request_type_names.shift, opt.text
        end
      end
    end
  end
end
