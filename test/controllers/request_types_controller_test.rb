require 'test_helper'

class RequestTypesControllerTest < ActionController::TestCase
  setup do
    @request_type = request_types(:one)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:request_types)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create request_type' do
    assert_difference('RequestType.count') do
      post :create, request_type: { code: 'NEW_REQ_TYPE', name: @request_type.name }
    end

    assert_redirected_to request_type_path(assigns(:request_type))
  end

  test 'should show request_type' do
    get :show, id: @request_type
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @request_type
    assert_response :success
  end

  test 'should update request_type' do
    patch :update, id: @request_type, request_type: { code: @request_type.code, name: @request_type.name }
    assert_redirected_to request_type_path(assigns(:request_type))
  end

  test 'should destroy request_type' do
    assert_equal true, @request_type.allow_delete?
    assert_difference('RequestType.count', -1) do
      delete :destroy, id: @request_type
    end

    assert_redirected_to request_types_path
  end

  test 'should show error when cannot destroy request type with associated records' do
    request_type = request_types(:new)
    assert_equal false, request_type.allow_delete?
    assert_no_difference('RequestType.count') do
      delete :destroy, id: request_type
    end
    assert !flash.empty?

    assert_redirected_to request_types_path
  end
end
