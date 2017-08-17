require 'test_helper'

class OrganizationsControllerTest < ActionController::TestCase
  
  setup do
    session[:cas] = { user: "admin" } 
    @organization = Organization.last
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:organizations)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create unit' do
    assert_difference('Organization.count') do
      post :create, organization: {
        code: 'NEW_UNIT', organization_id: @organization.id, name: SecureRandom.hex,
        organization_type: "unit"}
    end

    assert_redirected_to organizations_path
  end

  test 'should show unit' do
    get :show, id: @organization
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @organization
    assert_response :success
  end

  test 'should update unit' do
    patch :update, id: @organization, organization: {
      code: @organization.code,  organization_id: @organization.parent,  name: @organization.name }
    assert !flash.empty?
    assert_redirected_to organizations_path
  end

  test 'should destroy unit' do
    org = Organization.new(code: 'TEST_UNIT', name: 'Test Unit',
                           organization_id: @organization.id, organization_type: "unit")
    org.save!
    assert_difference('Organization.count', -1) do
      delete :destroy, id: org
    end

    assert_redirected_to organizations_path
  end

  test 'should show error when cannot destroy unit with associated records' do
    assert_no_difference('Organization.count') do
      delete :destroy, id: @organization
    end
    assert !flash.empty?

    assert_redirected_to organizations_path
  end

  test 'forbid access by non-admin user' do
    run_as_user(users(:not_admin)) do
      get :index
      assert_response :forbidden

      get :new
      assert_response :forbidden

      get :show, id: @organization
      assert_response :forbidden

      get :edit, id: @organization
      assert_response :forbidden

      post :create, unit: {
        code: 'NEW_UNIT', organization_id: @organization.organization_id, name: @organization.name,
        organization_type: "unit" }
      assert_response :forbidden

      patch :update, id: @organization, unit: {
        code: @organization.code, organization_id: @organization.organization_id, name: @organization.name,
        organization_type: "unit" }
      assert_response :forbidden

      delete :destroy, id: @organization
      assert_response :forbidden
    end
  end
end
