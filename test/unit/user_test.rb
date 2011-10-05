require 'test_helper'

class UserTest < ActiveSupport::TestCase

  # A new basic user should be able to be created.
  test "create new user" do
    u = User.new(:username => 'newuser', :rpassword => 'tester', :name => 'New User', :is_admin => false)
    assert u.valid?
  end

  # A fixture has already been created with the username 'mrmanrin' so
  # the save should fail.
  test "username must be unique" do
    u = User.new(:username => 'mrmanrin', :rpassword => 'tester', :name => 'Michael Manring', :is_admin => false)
    assert ! u.valid?

    u.username = 'mrmanrin2'
    assert u.valid?
  end

  # Username must not contain characters other than alphanumerics.
  test "username character requirement" do
    u = User.new(:username => 'th!si$b@d', :rpassword => 'tester', :name => 'Bad Username', :is_admin => false)
    assert ! u.valid?

    u.username = 'th1si5b4d'
    assert u.valid?
  end

  # Password must be at least 6 characters long.
  test "password length requirement" do
    u = User.new(:username => 'newuser', :rpassword => 'short', :name => 'New User', :is_admin => false)
    assert ! u.valid?

    u.rpassword = 'shorter'
    assert u.valid?
  end

  # A user's name must be provided.
  test "user name requirement" do
    u = User.new(:username => 'newuser', :rpassword => 'tester', :name => '', :is_admin => false)
    assert ! u.valid?

    u.name = 'a'
    assert u.valid?
  end

  # The is_admin field should be either true or false.
  test "is admin should be a boolean" do
    u = User.new(:username => 'newuser', :rpassword => 'tester', :name => 'New User', :is_admin => 'true')
    assert ! u.valid?

    u.is_admin = false
    assert u.valid?
  end

  # Bad credentials should fail and valid credentials should work.
  test "authentication credentials" do
    assert ! User.authenticate('mrmanrin', 'thisisabadpassword')
    assert User.authenticate('mrmanrin', 'tester')
  end

  # Password should be encrypted correctly.
  test "password encryption" do
    assert 'f0b2de5917a9c2fbbd987244339c995dbc8f0d6b' == User.encrypt_pw('tester')
  end

  # Make sure that only administrators can create administrator accounts.
  test "admin can create admins" do
    # First, get a user that is already an admin.
    @current_user = User.where('is_admin = ?', true).first

    # Then, try to create the user with as an admin.
    u = User.new(:username => 'newadmin', :rpassword => 'tester', :name => 'New Admin', :is_admin => true)
    u.current_userid = @current_user.id
    assert u.save

    # This should fail.
    @current_user = User.where('is_admin = ?', false).first
    u = User.new(:username => 'newadmin', :rpassword => 'tester', :name => 'New Admin', :is_admin => true)
    u.current_userid = @current_user.id
    assert ! u.save
  end

end
