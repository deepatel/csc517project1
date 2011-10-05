# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
#User.create(:username => 'mrmanrin', :password => User.encrypt_pw('test'), :name => 'Michael Manring', :email => 'mrmanrin@ncsu.edu', :is_admin => true)
#User.create(:username => 'dapatel2', :password => User.encrypt_pw('test2'), :name => 'Dhaval Patel', :is_admin => false)

user = User.new(:username => 'admin', :rpassword => 'Password1', :name => 'Admin User', :is_admin => true)
user.save(false)

#Post.create(:user_id => 1, :data => "Do you know where my brain is?")