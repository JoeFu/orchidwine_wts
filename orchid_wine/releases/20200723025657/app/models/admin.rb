# encoding: utf-8
class Admin < ApplicationRecord
  has_many :users
  has_many :import_companies
  before_create :encrypt_password

  # integer is_delete 是否删除 0-否 1-是

  def encrypt_password
    self.encrypt  = String.sample(16)
    self.password = Digest::MD5.hexdigest((password || '123WsxG45678') + encrypt)
  end

  def password_validate?(param_passwd)
    password == Digest::MD5.hexdigest(param_passwd + encrypt)
  end

  def show_name
    true_name.present? ? true_name : user_name
  end

  ROLE = {
    0 => '超级管理员',
    1 => '系统管理员',
    2 => '销售',
    3 => '出口服务部',
    4 => '财务主管',
    5 => '生产主管',
    6 => '官网管理员',
  }

  CREATE_ADMIN_ROLE = {
    1 => '系统管理员',
    2 => '销售',
    3 => '出口服务部',
    4 => '财务主管',
    5 => '生产主管',
    6 => '官网管理员',
  }

  def role_show
    Admin::ROLE[role]
  end

  def self.sellers_pluck(ids = nil)
    users = self.where(:is_delete => 0, :role => 2)
    if ids.present?
      users = users.where(id: ids)
    end

    users.map do |ad|
      [ad.id, ad.show_name]
    end
  end

  def self.sellers_options
    [[0, '全部']] + sellers_pluck
  end

  def my_users
    users.map do |user|
      [user.id, [user.name, user.company_code, user.company].join(' - ')]
    end
  end

  def self.cc_emails
    emails = []
    self.where(:is_delete => 0, :role => [4, 5]).map do |admin|
      # 'Jason Zhao<jason.zhao@orchidwine.com.au>'
      emails << "#{admin.show_name}<#{admin.email}>"
    end
    emails << "Vicky Wang<vicky.wang@orchidwine.com.au>"
    # emails << "Joe Fu<joe.fu@orchidwine.com.au>"
    # emails << "wuyue<wuyueit@gmail.com>"

    emails.join(', ')
  end

  def self.set1
    Admin.all.map do |a|
      a.password = 1
      a.encrypt_password
      a.save
    end
  end
end
