require 'test_helper'

class RoleCutoffsControllerTest < ActionController::TestCase
  setup do
    @role_cutoff = role_cutoffs(:one)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:role_cutoffs)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create role_cutoff' do
    assert_difference('RoleCutoff.count') do
      post :create, role_cutoff: { cutoff_date: @role_cutoff.cutoff_date, role_type_id: role_types(:two).id }
    end

    assert_redirected_to role_cutoff_path(assigns(:role_cutoff))
  end

  test 'should show role_cutoff' do
    get :show, id: @role_cutoff
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @role_cutoff
    assert_response :success
  end

  test 'should update role_cutoff' do
    patch :update, id: @role_cutoff,
                   role_cutoff: { cutoff_date: @role_cutoff.cutoff_date, role_type_id: @role_cutoff.role_type_id }
    assert_redirected_to role_cutoff_path(assigns(:role_cutoff))
  end

  test 'should destroy role_cutoff' do
    assert_difference('RoleCutoff.count', -1) do
      delete :destroy, id: @role_cutoff
    end

    assert_redirected_to role_cutoffs_path
  end
end
