require 'test_helper'

class DivisionsControllerTest < ActionController::TestCase
  setup do
    @division = divisions(:one)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:divisions)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create division' do
    assert_difference('Division.count') do
      post :create, division: { code: 'NEW_DIV', name: @division.name }
    end

    assert_redirected_to division_path(assigns(:division))
  end

  test 'should show division' do
    get :show, id: @division
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @division
    assert_response :success
  end

  test 'should update division' do
    patch :update, id: @division, division: { name: @division.name }
    assert_redirected_to division_path(assigns(:division))
  end

  test 'should destroy division' do
    division = Division.new(code: 'TEST_DIV', name: 'Test Division')
    division.save!
    assert_equal true, division.allow_delete?
    assert_difference('Division.count', -1) do
      delete :destroy, id: division
    end

    assert_redirected_to divisions_path
  end

  test 'should show error when cannot destroy division with associated records' do
    assert_equal false, @division.allow_delete?
    assert_no_difference('Division.count') do
      delete :destroy, id: @division
    end
    assert !flash.empty?

    assert_redirected_to divisions_path
  end

  test 'forbid access by non-admin user' do
    run_as_user(users(:test_not_admin)) do
      get :index
      assert_response :forbidden

      get :new
      assert_response :forbidden

      get :show, id: @division
      assert_response :forbidden

      get :edit, id: @division
      assert_response :forbidden

      post :create, division: { code: 'NEW_DIV', name: @division.name }
      assert_response :forbidden

      patch :update, id: @division, division: { name: @division.name }
      assert_response :forbidden

      delete :destroy, id: @division
      assert_response :forbidden
    end
  end
end
