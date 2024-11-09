# encoding: utf-8
class User < ApplicationRecord
  has_many :orders,  -> {where('status not in (7,8)')}
  has_many :productions
  belongs_to :admin

  before_create :encrypt_password

  def encrypt_password
    self.encrypt  = String.sample(16)
    self.password = Digest::MD5.hexdigest((password || '12345678') + encrypt)
  end

  def password_validate?(param_passwd)
    password == Digest::MD5.hexdigest(param_passwd + encrypt)
  end

  USER_ROLE = {
    1 => '普通客户',
    2 => '中级客户',
    3 => '高级客户'
  }

  SEX = {
    0 => '男',
    1 => '女'
  }

  def show_role_name
    USER_ROLE[role]
  end

  def sex_show
    User::SEX[sex]
  end

  def self.inc_ip_count(user_ip)
    Rails.cache.write "login/#{user_ip}", ip_count(user_ip) + 1, :expires_in => 300.seconds
  end

  def self.ip_count(user_ip)
    Rails.cache.read("login/#{user_ip}").to_i
  end

  def admin_name
    admin.show_name rescue "未指定"
  end

  def full_show(_break = false)
    [name, [company_code].join(' - ')].join(_break ? '<br/>' : ' - ')
  end

  def a_link(_break = false)
    "<a class=\"btn-link\" href=\"/admin/users/#{id}\">#{name}</a>"
  end
end
