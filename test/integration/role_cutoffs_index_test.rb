require 'test_helper'

# Integration test for the Role Cutoffs index page
class RoleCutoffsIndexTest < ActionDispatch::IntegrationTest
  test 'index including sorting' do
    columns = %w(role_type_name cutoff_date)

    get role_cutoffs_path
    assert_template 'role_cutoffs/index'

    # Verify sort links
    assert_select 'a.sort_link', count: columns.size

    # Verify sorting
    columns.each do |column|
      %w(asc desc).each do |order|
        q_param = { s: column + ' ' + order }
        get role_cutoffs_path, q: q_param
        assert_template 'role_cutoffs/index'

        RoleCutoff.ransack(q_param).result.each do |entry|
          assert_select 'a[href=?]', role_cutoff_path(entry)
        end
      end
    end
  end
end
