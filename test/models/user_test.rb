require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup 
    @user = User.new( name: "Example User", email: "user@example.com",
      password: "foobar", password_confirmation: "foobar" )
 
  end 

  test "should redirect index when not logged in" do 
    get :index 
    assert_redirected_to login_url 
  end


  test "should be valid" do 
    assert @user.valid? 
  end

  test "name should be present" do 
    @user.name = " " 
    assert_not @user.valid? 
  end

  test "email should be present" do 
    @user.email = " " 
    assert_not @user.valid? 
  end

test "name should not be too long" do 
  @user.name = "a" * 51 
  assert_not @user.valid? 
end 

test "email should not be too long" do 
  @user.email = "a" * 244 + "@example.com" 
  assert_not @user.valid? 
end 

test "email validation should accept valid addresses" do 
  valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org 
    first.last@foo.jp alice+bob@baz.cn] 
    valid_addresses.each do |valid_address| 
      @user.email = valid_address assert @user.valid?, "#{valid_address.inspect} should be valid"

  end
end

test "email addresses should be unique" do 
  duplicate_user = @user.dup
  duplicate_user.email = @user.email.upcase 
  @user.save 
  assert_not duplicate_user.valid? 
end

test "email addresses should be saved as lower-case" do 
  mixed_case_email = "Foo@ExAMPle.CoM" 
  @user.email = mixed_case_email 
  @user.save assert_equal mixed_case_email.downcase, @user.reload.email 
end


test "password should have a minimum length" do 
  @user.password = @user.password_confirmation = "a" * 5 
  assert_not @user.valid? 
 end

 test "authenticated? should return false for a user with nil digest" do 
  assert_not @user.authenticated?(:remember, '') 
end

test "should follow and unfollow a user" do 
  michael = users(:michael) 
  archer = users(:archer) 
  assert_not michael.following?(archer) 
  michael.follow(archer) 
  assert michael.following?(archer)
  assert archer.followers.include?(michael)
   michael.unfollow(archer) 
  assert_not michael.following?(archer) end
end
test "feed should have the right posts" do 
  michael = users(:michael) 
  archer = users(:archer) 
  lana = users(:lana) 
  
  # Posts from followed user 
  lana.microposts.each do |post_following| 
    assert michael.feed.include?(post_following) 
  end 
  # Posts from self 
  michael.microposts.each do |post_self| 
    assert michael.feed.include?(post_self) 
  end 
  # Posts from unfollowed user 
  archer.microposts.each do |post_unfollowed| 
    assert_not michael.feed.include?(post_unfollowed) 
  end 
end

end