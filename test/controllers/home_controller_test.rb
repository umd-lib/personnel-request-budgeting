require 'test_helper'

class HomeControllerTest < ActionController::TestCase


  test 'should not allow unauthed users' do
    get :index
    assert_response(401)
  end
  
  test 'should allow authed users' do
    run_as_user("not_admin") do  
      get :index
      assert_response(:success)
    end 
  end
end
