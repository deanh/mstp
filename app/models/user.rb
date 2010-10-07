require 'digest/sha1'

class User < ActiveRecord::Base
  validates_length_of :password, :within => 5..40
  validates_presence_of :email, :password, :password_confirmation, :salt
  validates_uniqueness_of :email
  validates_confirmation_of :password
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "Invalid email"  

  attr_protected :id, :salt

  attr_accessor :password, :password_confirmation

  def self.authenticate email, pass
    u = find(:first, :conditions => ["email = ?", email])
    return nil if u.nil?
    return u if User.encrypt(pass, u.salt) == u.crypted_password
    nil
  end  

  def password= pass 
    @password = pass
    self.salt = User.random_string(10) if !self.salt?
    self.crypted_password = User.encrypt(@password, self.salt)
  end

  def password
    @password || crypted_password
  end

  def password_confirmation
    @password_confirmation || crypted_password
  end

  def send_new_password
    new_pass = User.random_string(10)
    self.password = self.password_confirmation = new_pass
    self.save
    #Notifications.deliver_forgot_password(self.email, self.login, new_pass)
  end

  protected

  def self.encrypt pass, salt 
    Digest::SHA1.hexdigest pass+salt
  end

  def self.random_string len
    #generat a random password consisting of strings and digits
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    rand_str = ""
    1.upto(len) { |i| rand_str << chars[rand(chars.size-1)] }
    return rand_str
  end

  def password_check
    if crypted_password or (password == password_confirmation and !password.nil?)
      return true
    end
  end
end
