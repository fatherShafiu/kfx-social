require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup 
    @user = users(:michael) 
    @other_user = users(:archer) 
  end

  test "should get new" do
    get users_new_url
    assert_response :success
  end
  test "should redirect edit when not logged in" do 
    get :edit, id: @user 
    assert_not flash.empty? 
    assert_redirected_to login_url 
  end 
  
  test "should redirect update when not logged in" do 
    patch :update, id: @user, user: { name: @user.name, email: @user.email } 
    assert_not flash.empty? 
    assert_redirected_to login_url 
  end

  test "should redirect edit when logged in as wrong user" do 
    log_in_as(@other_user) 
    get :edit, id: @user 
    assert flash.empty?
    assert_redirected_to root_url 
  end

  test "should redirect update when logged in as wrong user" do 
    log_in_as(@other_user) 
    patch :update, id: @user, user: { name: @user.name, email: @user.email } 
    assert flash.empty? 
    assert_redirected_to root_url 
  end 

  test "should not allow the admin attribute to be edited via the web" do 
    log_in_as(@other_user) 
    assert_not @other_user.admin? 
    patch :update, id: @other_user, user: { password: FILL_IN, password_confirmation: FILL_IN, admin: FILL_IN } 
    assert_not @other_user.FILL_IN.admin? 
  
  end

  test "should redirect following when not logged in" do 
    get :following, id: @user 
    assert_redirected_to login_url 
  end 
  
  test "should redirect followers when not logged in" do 
    get :followers, id: @user 
    assert_redirected_to login_url 
  end 
end