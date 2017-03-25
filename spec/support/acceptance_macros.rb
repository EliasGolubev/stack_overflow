module AcceptanceMacros
  DEFAULT_REGISTRATION = {
    username:              'user',
    email:                 'user@email.com',
    password:              '12345678',
    password_confirmation: '12345678'     
  }.freeze

  DEFAULT_QUESTION_FORM = {
    action: 'new',
    title: 'Question title text',
    body:  'Question body text'
  }.freeze

  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def registration_user(param = {})
    param = DEFAULT_REGISTRATION.merge(param)

    visit new_user_registration_path
    fill_in       'Username',               with: param[:username]
    fill_in       'Email',                  with: param[:email]
    fill_in       'Password',               with: param[:password]
    fill_in       'Password confirmation',  with: param[:password_confirmation]
    click_button  'Sign up'
  end

  def question_form(param = {})
    param = DEFAULT_QUESTION_FORM.merge(param)

    fill_in 'Title',          with: param[:title]
    fill_in 'Question text',  with: param[:body]

    click_on 'Ask question'   if param[:action] == 'new'
    click_on 'Edit question'  if param[:action] == 'edit'
  end
end