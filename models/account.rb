class Account
  include Mongoid::Document
  include Mongoid::Timestamps 
  attr_accessor :password, :password_confirmation
  belongs_to  :website
  belongs_to  :state
  belongs_to :credit_info
  has_one :address,dependent: :delete
  belongs_to :node
  # Fields
  field :name,             :type => String
  field :surname,          :type => String
  field :email,            :type => String
  field :crypted_password, :type => String
  field :role,             :type => String
  field :website_id,             :type => String
  field :admin,             :type => Integer
  field :mobile,        :type => String
  field :admin_type,  :type => String

  # Validations
  validates_presence_of     :mobile, :role
  validates_presence_of     :password,                   :if => :password_required
  validates_presence_of     :password_confirmation,      :if => :password_required
  validates_length_of       :password, :within => 4..40, :if => :password_required
  validates_length_of       :mobile,:is=>11
  validates_confirmation_of :password,                   :if => :password_required
  #validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :mobile
  #validates_format_of       :email,    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_format_of       :role,     :with => /[A-Za-z]/

  # Callbacks
  before_save :encrypt_password, :if => :password_required

  ##
  # This method is for authentication purpose.
  #
  def self.authenticate(email, password)
    account = where(:email => /#{Regexp.escape(email)}/i).first if email.present?
    account && account.has_password?(password) ? account : nil
    if account
   if account.admin != 1
        nil
    else
       account
    end
  end
  end

    def self.authenticate_mobile(mobile, password)
    account = where(:mobile=> mobile).first 
    account && account.has_password?(password)  ? account : nil
  end

 
  def self.login(email, password)
    account = where(:email => /#{Regexp.escape(email)}/i).first if email.present?
    account && account.has_password?(password) ? account : nil
  end

  ##
  # This method is used by AuthenticationHelper.
  #
  def self.find_by_id(id)
    find(id) rescue nil
  end

  def has_password?(password)
    ::BCrypt::Password.new(crypted_password) == password
  end

  private

  def encrypt_password
    self.crypted_password = ::BCrypt::Password.create(self.password)
  end

  def password_required
    crypted_password.blank? || self.password.present?
  end
end
