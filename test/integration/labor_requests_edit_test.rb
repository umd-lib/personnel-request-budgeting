require 'test_helper'

# Integration test for the LaborRequest edit page
# rubocop:disable Metrics/ClassLength
class LaborRequestsEditTest < ActionDispatch::IntegrationTest
  def setup
    @labor_request = labor_requests(:fac_hrly_renewal)
    @division1 = divisions_with_records[0]
    @division1_user = User.create(cas_directory_id: 'division1', name: 'Division1 User')
    Role.create!(user: @division1_user,
                 role_type: RoleType.find_by_code('division'),
                 division: @division1)
  end

  test 'currency field values show with two decimal places' do
    get edit_labor_request_path(@labor_request)

    currency_fields = %w(labor_request_hourly_rate labor_request_nonop_funds)
    currency_fields.each do |field|
      assert_select "[id=#{field}]" do |e|
        verify_two_digit_currency_field(field, e.attribute('value'))
      end
    end
  end

  test '"Edit" button should only be shown if policy allows edit' do
    run_as_user(@division1_user) do
      labor_requests_all = LaborRequest.all

      labor_requests_all.each do |r|
        get labor_request_path(r)
        if Pundit.policy!(@division1_user, r).edit?
          assert_select "[id='button_edit']", 1,
                        "'#{@division1.code}' user could NOT edit " \
                        "'#{r.id}' with division '#{r.department.division.code}'"
        else
          assert_select "[id='button_edit']", 0,
                        "'#{@division1.code}' user could edit " \
                        "'#{r.id}' with division '#{r.department.division.code}'"
        end
      end
    end

    Role.destroy_all(user: @division1_user)
    @division1_user.destroy!
  end

  test 'can edit review_status or review_comments' do
    get edit_labor_request_path(@labor_request)
    assert_select "select#labor_request_review_status_id[disabled='disabled']", false
    assert_select "textarea#labor_request_review_comment[disabled='disabled']", false
  end

  test 'Non-admins cannot edit review_status or review_comments' do
    run_as_user(@division1_user) do
      get edit_labor_request_path(@labor_request)
      assert_select "select#labor_request_review_status_id[disabled='disabled']"
      assert_select "textarea#labor_request_review_comment[disabled='disabled']"
    end
  end

  test 'can only see departments/units allowed by role in drop-downs' do
    labor_request_with_unit = labor_requests(:fac_hrly_with_unit)
    with_temp_user(units: [labor_request_with_unit.unit.code]) do |temp_user|
      run_as_user(temp_user) do
        get edit_labor_request_path(labor_request_with_unit)

        # Verify department options
        doc = Nokogiri::HTML(response.body)
        dept_options = doc.xpath("//select[@id='labor_request_department_id']/option")
        depts = dept_options.map(&:text)
        assert_equal 1, depts.size
        expected_unit = labor_request_with_unit.unit
        expected_dept = expected_unit.department
        assert depts.include?(expected_dept.name)

        # Verify unit options
        unit_options = doc.xpath("//select[@id='labor_request_unit_id']/option")
        units = unit_options.map(&:text)
        assert_equal 2, units.size # 2, because of "Clear Unit" option
        assert units.include?(expected_unit.name)
      end
    end
  end

  test 'can only see departments/units allowed by role in drop-downs with role cutoffs' do
    labor_request = labor_requests(:c1) # c1 is in SSDR department
    department_for_role = labor_request.department
    unit_for_role = units(:one)
    with_temp_user(departments: [department_for_role.code], units: [unit_for_role.code]) do |temp_user|
      run_as_user(temp_user) do
        unit_role_cutoff = role_cutoffs(:unit)
        unit_role_cutoff.cutoff_date = 1.day.from_now
        unit_role_cutoff.save!

        get edit_labor_request_path(labor_request)

        # Verify department options
        doc = Nokogiri::HTML(response.body)
        dept_options = doc.xpath("//select[@id='labor_request_department_id']/option")
        depts_text = dept_options.map(&:text)
        assert_equal 2, depts_text.size
        assert depts_text.include? unit_for_role.department.name
        assert depts_text.include? labor_request.department.name

        # Verify unit options
        unit_options = doc.xpath("//select[@id='labor_request_unit_id']/option")
        units = unit_options.map(&:text)
        assert_equal 1, units.size
        assert units.include?(unit_for_role.name)

        unit_role_cutoff = role_cutoffs(:unit)
        unit_role_cutoff.cutoff_date = 1.day.ago
        unit_role_cutoff.save!

        get edit_labor_request_path(labor_request)

        # Verify department options - should no longer include department for unit
        doc = Nokogiri::HTML(response.body)
        dept_options = doc.xpath("//select[@id='labor_request_department_id']/option")
        depts_text = dept_options.map(&:text)
        assert_equal 1, depts_text.size
        assert depts_text.include? labor_request.department.name

        # Verify unit options - should have no options
        unit_options = doc.xpath("//select[@id='labor_request_unit_id']/option")
        units = unit_options.map(&:text)
        assert units.empty?
      end
    end
  end
end
