require 'spec_helper'

describe User do
  
  before(:each) do
    @attr = { 
      :name => "Example User", 
      :email => "user@example.com", 
      :password => "foobar",
      :password_confirmation => "foobar"
    }
  end
  
  it "should create a new instace given valid attributes" do
    User.create!(@attr)
  end
  
  describe "name validation" do
    it "should require a name" do
      no_name_user = User.new(@attr.merge(:name => ""))
      no_name_user.should_not be_valid
    end
  
    it "should reject names that are too long" do
      long_name = "a" * 51
      long_name_user = User.new(@attr.merge(:name => long_name))
      long_name_user.should_not be_valid
    end
  end
  
  describe "email validation" do
    it "should require an email address" do
      no_email_user = User.new(@attr.merge(:email => ""))
      no_email_user.should_not be_valid
    end
  
    it "should accept valid email addresses" do
      addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
      addresses.each do |address|
        invalid_email_user = User.new(@attr.merge(:email => address))
        invalid_email_user.should be_valid
      end
    end
    
    it "should reject invalid email addresses" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
      addresses.each do |address|
        invalid_email_user = User.new(@attr.merge(:email => address))
        invalid_email_user.should_not be_valid
      end
    end
  
    it "should reject duplicate email addresses" do
      User.create(@attr)
      user_with_duplicate_email = User.new(@attr)
      user_with_duplicate_email.should_not be_valid
    end
  
    it "should reject duplicate email addresses insensitive to case" do
      upcased_email = @attr[:email].upcase
      User.create!(@attr.merge(:email => upcased_email))
      user_with_duplicate_email = User.new(@attr)
      user_with_duplicate_email.should_not be_valid
    end
  end
  
  describe "password validation" do
     
    it "should require a password" do
      User.new(@attr.merge(
        :password => "", 
        :password_confirmation => "")).should_not be_valid
    end
    
    it "should require a matching password confirmation" do
      User.new(@attr.merge(
        :password_confirmation => "invalid")).should_not be_valid
    end
    
    it "should reject short passwords" do
      short = "a" * 5
      User.new(@attr.merge(
        :password => short, 
        :password_confirmation => short)).should_not be_valid
    end
    
    it "should reject long passwords" do
      long = "a" * 41
      User.new(@attr.merge(
        :password => long, 
        :password_confirmation => long)).should_not be_valid
    end
  end
  
  describe "password encryption" do
    before(:each) do
      @user = User.create!(@attr)
    end
    
    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end
    
    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end
  end
end
