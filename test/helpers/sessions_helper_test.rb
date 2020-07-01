require 'test_helper' 
class SessionsHelperTest < ActionView::TestCase 
    def setup 
    @user = users(:michael) 
    remember(@user) 
    end 

    test "current_user returns right user when session is nil" do 
    assert_equal @user, current_user 
    assert is_logged_in? 
end 

test "current_user returns nil when remember digest is wrong" do 
    @user.update_attribute(:remember_digest, User.digest(User.new_token)) 
    assert_nil current_user 
end 

def current_user 
  if (user_id = session[:user_id]) 
   @current_user ||= User.find_by(id: user_id) 
  elsif (user_id = cookies.signed[:user_id]) 
   user = User.find_by(id: user_id) 
  if user && user.authenticated?(cookies[:remember_token]) 
   log_in user 
   @current_user = user 
  end 
  end 
end

def redirect_back_or(default) 
    redirect_to(session[:forwarding_url] || default) 
    session.delete(:forwarding_url) 
end

def store_location 
    session[:forwarding_url] = request.url if request.get? 
    end 
end
