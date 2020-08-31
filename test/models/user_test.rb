require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: 'sample user', email: 'sample@foo.bar',
                      password: 'foobar', password_confirmation: 'foobar')
  end

  test 'name should be present' do
    @user.name = ''
    assert_not @user.valid?
  end

  test 'email should be present' do
    @user.email = ''
    assert_not @user.valid?
  end

  test 'name should not be too long' do
    @user.name = 'a' * 51
    assert_not @user.valid?
  end

  test 'email should not be too long' do
    @user.email = 'a' * 250 + '@sample.com'
    assert_not @user.valid?
  end

  test 'email validation should accept valid address' do
    valid_addresses = %w[sample@foo.bar SaMPle@FOO.bar s_A_m_P_l_E@foo.bar foo+bar@sample.com]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test 'email valid should reject invalid address' do
    invalid_addresses = %w[sample,app@foo.bar foo.bar.com foo@bar@sample.com foo@bar+com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?
    end
  end

  test 'email address should be unique' do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test 'email should be saved as lower-case' do
    mixedcase_address = 'SaMPlE@FoO.BaR'
    @user.email = mixedcase_address
    @user.save
    assert_equal @user.reload.email, mixedcase_address.downcase
  end

  test 'password should be present' do
    @user.password = ' ' * 10
    assert_not @user.valid?
  end

  test 'password should have a minimum length' do
    @user.password = @user.password_confirmation = 'a' * 5
    assert_not @user.valid?
  end

  test 'authenticated? should return false if remember_digest is nil' do
    assert_not @user.authenticated?('')
  end
end
