require 'rails_helper.rb'

feature 'User sign in', %q{
  In order to be able to ask question
  As an User
  I want to be able to sign in
} do 

  scenario 'some description Registered user can sign in' do 
  end

  scenario 'some description Registered user not fill email field' do 
  end

  scenario 'some description Unregistered user can not sign in' do 
  end

  scenario 'some description No logged user can see Sign in button on root page' do 
  end

  scenario 'some description No logged user can see Sign in button on question page' do 
  end

  scenario 'some description No logged user can see Sign in button on my_question page' do 
  end

  scenario 'some description Logged user can not see Sign in button on root page' do 
  end

  scenario 'some description Logged user can not see Sign in button on question page' do 
  end
end