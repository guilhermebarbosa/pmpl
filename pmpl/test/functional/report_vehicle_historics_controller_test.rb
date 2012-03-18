require 'test_helper'

class ReportVehicleHistoricsControllerTest < ActionController::TestCase
  setup do
    @report_vehicle_historic = report_vehicle_historics(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:report_vehicle_historics)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create report_vehicle_historic" do
    assert_difference('ReportVehicleHistoric.count') do
      post :create, :report_vehicle_historic => @report_vehicle_historic.attributes
    end

    assert_redirected_to report_vehicle_historic_path(assigns(:report_vehicle_historic))
  end

  test "should show report_vehicle_historic" do
    get :show, :id => @report_vehicle_historic.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @report_vehicle_historic.to_param
    assert_response :success
  end

  test "should update report_vehicle_historic" do
    put :update, :id => @report_vehicle_historic.to_param, :report_vehicle_historic => @report_vehicle_historic.attributes
    assert_redirected_to report_vehicle_historic_path(assigns(:report_vehicle_historic))
  end

  test "should destroy report_vehicle_historic" do
    assert_difference('ReportVehicleHistoric.count', -1) do
      delete :destroy, :id => @report_vehicle_historic.to_param
    end

    assert_redirected_to report_vehicle_historics_path
  end
end
