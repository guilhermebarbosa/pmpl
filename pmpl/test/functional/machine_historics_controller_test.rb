require 'test_helper'

class MachineHistoricsControllerTest < ActionController::TestCase
  setup do
    @machine_historic = machine_historics(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:machine_historics)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create machine_historic" do
    assert_difference('MachineHistoric.count') do
      post :create, :machine_historic => @machine_historic.attributes
    end

    assert_redirected_to machine_historic_path(assigns(:machine_historic))
  end

  test "should show machine_historic" do
    get :show, :id => @machine_historic.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @machine_historic.to_param
    assert_response :success
  end

  test "should update machine_historic" do
    put :update, :id => @machine_historic.to_param, :machine_historic => @machine_historic.attributes
    assert_redirected_to machine_historic_path(assigns(:machine_historic))
  end

  test "should destroy machine_historic" do
    assert_difference('MachineHistoric.count', -1) do
      delete :destroy, :id => @machine_historic.to_param
    end

    assert_redirected_to machine_historics_path
  end
end
