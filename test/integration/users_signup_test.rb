require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do 
    get signup_path 
    assert_no_difference 'User.count' do 
      post users_path, user: { name: "", email: "user@invalid", password: "foo", 
        password_confirmation: "bar" 
        } 
      end 
      assert_template 'users/new' 
    end 

    test "valid signup information with account activation" do
      get signup_path 
      assert_difference 'User.count', 1 do 
        post users_path, user: { name: "Example User", email: "user@example.com", 
          password: "password", password_confirmation: "password" } 
        
        end 
        assert_template 'users/show' 
        assert is_logged_in?
      end 

      def setup 
        ActionMailer::Base.deliveries.clear 
      end
    end


    
