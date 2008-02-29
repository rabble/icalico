require 'digest/sha1'
class User < ActiveRecord::Base
  # Virtual attribute for the unencrypted password
  attr_accessor :password

  #has_one :list
  #has_many :friends
  #has_many :friends, :through => 'friendships'
  has_and_belongs_to_many :friends, :class_name => 'User', :join_table => 'friends', :foreign_key => 'friend_id'
  has_and_belongs_to_many :talks, :uniq => true
  #has_and_belongs_to_many :upcoming_talks, :class_name => Talk, :conditions => ['start > DATE_SUB(NOW(), INTERVAL 20 MINUTE)']
  has_many :created_talks, :class_name => "Talk", :foreign_key => 'creator_id'
  has_many :attendances
  has_many :conferences, :through => :attendances
  
  
  validates_presence_of     :login
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
#  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :login, :case_sensitive => false
  validates_format_of       :login, :with => /^[\w_:\/\-\*\.\+?=&@ ]+$/
  before_save :encrypt_password

  
  def self.find_random(n=20)
    users = conference.attendees.find(:all, :order => 'rand()', :limit => n)
    return users.sort_by {|user| user.login}
  end
  

  def self.find_active(n=false)
    where = { 
      :select => "users.*, count(talks_users.user_id) as popularity",
      :joins => "LEFT JOIN talks_users on users.id = talks_users.user_id",
      :group => "talks_users.user_id",
      :order => 'popularity',
    }
    
    where[:limit] = n if n
    
    users = conference.attendees.find(:all, where)
    
    return users.sort_by {|user| user.login}
  end

  def self.find_popular(n=20)
    sql = "select u.*, count(j.user_id) as popularity from users u, talks_users j"
    sql << " where u.id = j.user_id group by j.user_id order by popularity desc limit #{n}"
    @users = User.find_by_sql(sql)
    # re-sort by date
    return @users.sort_by {|user| user.login}
  end


  def upcoming_talks
    sql = "SELECT * FROM talks INNER JOIN talks_users ON talks.id = talks_users.talk_id "
    sql << "WHERE (talks_users.user_id = #{self.id} ) AND "
    sql << "start > DATE_SUB(NOW(), INTERVAL 195 MINUTE) "
    sql << " order by start asc"
    Talk.find_by_sql(sql)
  end

  def bookmark(talk)
    unless self.talks.include?(talk)
      self.talks << talk
    end
  end
  
  def friends_talks
    
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end
  

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    self.remember_token_expires_at = 2.weeks.from_now.utc
    self.remember_token            = encrypt("#{login}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
    
    def password_required?
      return false if openid
      crypted_password.blank? || !password.blank?
    end
end
