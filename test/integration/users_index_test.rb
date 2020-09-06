require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:take)
    @non_admin = users(:edward)
  end

  test 'index as admin including pagination and delete links' do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination', count: 2
    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      assert_select 'a[href=?]', user_path(user), text: 'Delete' unless user == @admin
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test 'index as non-admin' do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'Delete', count: 0
  end

  test 'index as not activated user' do
    log_in_as(@admin)
    @non_admin.update_attribute(:activated,false)
    get users_path
    assert_select 'a[href=?]', user_path(@non_admin), count: 0
  end
end
