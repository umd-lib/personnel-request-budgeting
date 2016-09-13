require 'test_helper'

class ReviewStatusesControllerTest < ActionController::TestCase
  setup do
    @review_status = review_statuses(:started)
    @review_status_with_nutting = review_statuses(:never)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:review_statuses)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create review_status' do
    assert_difference('ReviewStatus.count') do
      post :create, review_status: { color: @review_status.color, name: @review_status.name }
    end

    assert_redirected_to review_status_path(assigns(:review_status))
  end

  test 'should show review_status' do
    get :show, id: @review_status
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @review_status
    assert_response :success
  end

  test 'should update review_status' do
    patch :update, id: @review_status, review_status: { color: @review_status.color, name: @review_status.name }
    assert_redirected_to review_status_path(assigns(:review_status))
  end

  test 'should destroy review_status' do
    assert_difference('ReviewStatus.count', -1) do
      delete :destroy, id: @review_status_with_nutting
    end

    assert_redirected_to review_statuses_path
  end

  test 'forbid access by non-admin user' do
    run_as_user(users(:test_not_admin)) do
      get :index
      assert_response :forbidden

      get :new
      assert_response :forbidden

      get :show, id: @review_status
      assert_response :forbidden

      get :edit, id: @review_status
      assert_response :forbidden

      post :create, review_status: { color: 'black', name: @review_status.name }
      assert_response :forbidden

      patch :update, id: @review_status, review_status: { color: 'white', name: @review_status.name }
      assert_response :forbidden

      delete :destroy, id: @review_status
      assert_response :forbidden
    end
  end
end
