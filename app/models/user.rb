class User < ActiveRecord::Base
  has_many :posts
  has_many :votes

  # Attributed used to store the password passed in by the forms. This is necessary
  # to be able to encrypt the password before storing it into the database.
  attr_accessor :rpassword

  # Attribute used when creating or editing a user. The currently logged in user's id
  # is stored here for use with validation.
  attr_accessor :current_userid

  # Validations
  # The username is required, must be alphanumeric characters, and must be unique in the database.
  validates :username, :format => { :with => /\A[a-zA-Z0-9]+\z/, :message => "The username must be present and only contain alphanumeric characters." }
  validates :username, :uniqueness => true

  # The user must provide their name.
  validates :name, :presence => true

  # The is_admin field must be a boolean.
  validates :is_admin, :inclusion => { :in => [true, false] }

  # Password field is required and must be at least 6 characters long if it is a new
  # user or if the editing user provided a password.
  validate :password_requirements
  def password_requirements
    if id.nil? or ! rpassword.empty?
      errors.add(:base, "You must provide a password at least 6 characters long.") if rpassword.length < 6
    end
  end

  # Only administrators should be able to create administrator accounts.
  validate :only_admins_can_create_admins
  def only_admins_can_create_admins
    if is_admin and (current_userid.nil? or ! User.find(current_userid).is_admin)
      errors.add(:base, "Only administrators can create administrators.")
    end
  end

  # Callback necessary to encrypt the password before saving it.
  before_save do |u|
    if ! u.rpassword.empty?
      u.password = User.encrypt_pw(u.rpassword)
    end
  end

  # Function to check the username and password provided by the login form and return
  # the result of the query.
  def self.authenticate(u, p)
    User.find(:first, :conditions => ["username = ? AND password = ?", u, User.encrypt_pw(p)])
  end

  def self.encrypt_pw(p)
    Digest::SHA1.hexdigest(SALT_KEY + p)
  end

end
