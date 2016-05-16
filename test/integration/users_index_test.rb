require 'test_helper'

# Integration test for the User index page
class UsersIndexTest < ActionDispatch::IntegrationTest
  test 'index including sorting' do
    columns = %w(cas_directory_id name)

    get users_path
    assert_template 'users/index'

    # Verify sort links
    assert_select 'a.sort_link', count: columns.size

    # Verify sorting
    columns.each do |column|
      %w(asc desc).each do |order|
        q_param = { s: column + ' ' + order }
        get users_path, q: q_param
        assert_template 'users/index'

        User.ransack(q_param).result.each do |entry|
          assert_select 'a[href=?]', user_path(entry)
        end
      end
    end
  end
end
