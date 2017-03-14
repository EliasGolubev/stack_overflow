require 'rails_helper.rb'

feature 'User registration', %q{
  In order to be able to sign in
  As an User
  I want to be able to registration
} do 

  scenario 'some description User fill all registration field' do 
  end

  scenario 'some description User not fill username' do 
  end

  scenario 'some description User not fill email' do 
  end

  scenario 'some description User not fill password' do 
  end

  scenario 'some description User not fill conf password' do 
  end

  scenario 'some description User fill email already exist' do 
  end

  scenario 'some description User password less six symbol' do 
  end

  scenario 'some description No logged user can see button Sign up on root page' do 
  end

  scenario 'some description No logged user can see button Sign up on question page' do
  end

  scenario 'some description Logged user can not see button Sign up on root page' do 
  end

  scenario 'some description Logged user can not see button Sign up on question page' do 
  end
end