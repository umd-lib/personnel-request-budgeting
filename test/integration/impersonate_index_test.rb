require 'test_helper'

# Integration test for the Impersonate index page
class ImpersonateIndexTest < ActionDispatch::IntegrationTest
  test 'index including sorting' do
    sorted_columns = %w(cas_directory_id name)

    get impersonate_path
    assert_template 'impersonate/index'

    # Verify sort links
    assert_select 'a.sort_link', count: sorted_columns.size

    # Verify sorting
    admin = users(:test_admin)
    run_as_user(admin) do
      sorted_columns.each do |column|
        %w(asc desc).each do |order|
          q_param = { s: column + ' ' + order }
          get impersonate_path, q: q_param
          assert_template 'impersonate/index'

          User.ransack(q_param).result.each do |entry|
            # Each user should have an impersonate link, unless they are the
            # current user, or an admin
            if (entry.cas_directory_id == admin.cas_directory_id) || entry.admin?
              assert_select 'a[href=?]', impersonate_user_path(entry), false
            else
              assert_select 'a[href=?]', impersonate_user_path(entry)
            end
          end
        end
      end
    end
  end
end
