require 'test_helper'


class ContractorRequestsControllerTest < ActionController::TestCase

  # by default these test run as admin. 
  setup do
    @contractor_request = ContractorRequest.first 
    @archived_contractor_request = ArchivedContractorRequest.first 
    session[:cas] = { user: "admin" } 
  end
  
  test 'should not allow unauthed users' do
    run_as_user(nil) do  
      get :index
      assert_response(401)
    end 
  end
  
  test 'should not allow users with bad/fake user accounts' do
    run_as_user("gary") do  
      get :index
      assert_response(403)
    end 
  end
  
  test 'should allow authed users index' do
    get :index
    assert_response(200)
    assert assigns(:model_klass), ContractorRequest
    assert_not_nil assigns(:requests)
  end
  
  test 'should allow authed users to new' do
    get :new
    assert_response(200)
  end


  test 'should show contractor_request' do
    get :show, id: @contractor_request
    assert_response :success
  end

  test 'should create contractor_request' do
    assert_difference('Request.count') do
      post :create, contractor_request: {
        contractor_name: @contractor_request.contractor_name,
        organization_id: @contractor_request.organization_id,
        employee_type: @contractor_request.employee_type,
        hours_per_week: @contractor_request.hours_per_week,
        justification: @contractor_request.justification,
        annual_base_pay: @contractor_request.annual_base_pay, 
        nonop_funds: @contractor_request.nonop_funds,
        nonop_source: @contractor_request.nonop_source,
        number_of_months: @contractor_request.number_of_months,
        position_title: @contractor_request.position_title,
        request_type: @contractor_request.request_type,
       }
    end

    assert_redirected_to contractor_request_path(assigns(:request))
    assert assigns(:model_klass), ContractorRequest
 		assert_instance_of ContractorRequest, assigns(:request)
  
	end

	test 'should not create invalid contractor_request' do
    assert_no_difference('Request.count') do
      post :create, contractor_request: {
        contractor_name: nil,
        organization_id: nil,
        employee_type: nil,
        hours_per_week: nil,
        justification: nil,
        nonop_funds: nil,
        nonop_source: nil,
        number_of_months: nil,
        position_title: nil,
        request_type: nil,
        }
    end
	end

  test 'should create/update contractor_request but without admin only values when not admin' do   
    run_as_user( :not_admin ) do 
      assert_difference('Request.count') do
        post :create, contractor_request: {
          contractor_name: @contractor_request.contractor_name,
          organization_id: @contractor_request.organization_id,
          employee_type: @contractor_request.employee_type,
          hours_per_week: @contractor_request.hours_per_week,
          justification: @contractor_request.justification,
          annual_base_pay: @contractor_request.annual_base_pay, 
          nonop_funds: @contractor_request.nonop_funds,
          nonop_source: @contractor_request.nonop_source,
          number_of_months: @contractor_request.number_of_months,
          position_title: @contractor_request.position_title,
          request_type: @contractor_request.request_type,
          review_status_id: review_statuses(:approved), 
          review_comment: "Hey hey hey" 
        }
      end

      assert_redirected_to contractor_request_path(assigns(:request))
      assert_equal review_statuses(:under_review).id, assigns(:request).review_status_id
      assert_nil assigns(:request).review_comment
    end
	end

	test 'should update contractor_request' do
    patch :update, id: @contractor_request, contractor_request: {
      contractor_name: @contractor_request.contractor_name,
      organization_id: @contractor_request.organization_id,
      employee_type: @contractor_request.employee_type,
      hours_per_week: @contractor_request.hours_per_week,
      justification: @contractor_request.justification,
      nonop_funds: @contractor_request.nonop_funds,
      nonop_source: @contractor_request.nonop_source,
      number_of_months: @contractor_request.number_of_months,
      position_title: @contractor_request.position_title,
      request_type: @contractor_request.request_type,
      review_status_id: @contractor_request.review_status_id,
      review_comment: @contractor_request.review_comment,
   		} 
		assert_redirected_to contractor_request_path(assigns(:request))
	end
	
	test 'should not update an invalid contractor_request' do
   	original_attrs = @contractor_request.attributes 
		patch :update, id: @contractor_request, contractor_request: {
      contractor_name: nil, organization_id: nil, employee_type: nil,
      hours_per_week: nil, justification: nil,
      nonop_funds: nil, nonop_source: nil, 
      number_of_months: nil, position_title: nil, request_type: nil,
      review_status_id: nil, review_comment: nil
   		} 
		assert_equal original_attrs, ContractorRequest.find(@contractor_request.id).attributes	
	end


	test 'should destroy contractor_request' do
    assert_difference('Request.count', -1) do
      delete :destroy, id: @contractor_request
    end

    assert_redirected_to contractor_requests_path
	end


  # ArchivedcontractorRequests
  test 'should allow users to see archive' do
    get :index, archive: true
    assert_response(200)
    assert assigns(:model_klass), ArchivedContractorRequest
    assert_not_nil assigns(:requests)
  end


  test 'should show archived contractor request' do
    get :show, id: @archived_contractor_request
    assert assigns(:request).archived_proxy? 
    assert_response :success
  end
	
  test 'should not destroy archived contractor_request' do
    assert_no_difference('Request.count', -1) do
      delete :destroy, id: @archived_contractor_request
    end
    assert_response(403)
	end

  

end
