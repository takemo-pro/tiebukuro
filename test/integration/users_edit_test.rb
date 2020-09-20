require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:take)
  end

  test 'unsuccessful edit' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: '',
                                              profile: 'unko' } }
    assert_template 'users/edit'
    assert_select 'div.alert'
  end

  test 'successful edit with friendly forwarding' do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    name = 'banana'
    email = 'apple@email.com'
    profile = 'hogehoge'
    image = fixture_file_upload('test/fixtures/sample_image2.jpeg','image/jpeg')
    patch user_path(@user), params: { user: { name: name,
                                              profile: profile,
                                              user_icon: image} }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal profile, @user.profile
    assert @user.user_icon.attached?
  end
end
