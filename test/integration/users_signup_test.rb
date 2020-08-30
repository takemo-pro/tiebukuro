require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test 'invalid signup information' do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: '',
                                          email: 'invalid@address',
                                          password: 'foooo',
                                          password_confirmation: 'barrr' } }
      assert_template 'users/new'
      assert_select 'div#errors_explanation'
    end
  end

  test 'valid signup information' do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: 'human',
                                          email: 'sample@test.com',
                                          password: 'foobar',
                                          password_confirmation: 'foobar' } }
    end
    follow_redirect!
    assert is_logged_in?
    assert_template 'users/show'
    assert_select 'div.alert-success'
  end
end
