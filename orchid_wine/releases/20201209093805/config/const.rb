# encoding: utf-8
module Const
  BASE_TITLE = '澳麒酒业'

  ROOT_PATH = Rails.env == 'development' ? Rails.root.to_s + '/public' : '/home/orchid/orchid_wine/shared/public'

  UPLOAD_IMAGE = File.join(ROOT_PATH, '/upload/images')
  UPLOAD_ATTACHMENT = File.join(ROOT_PATH, '/upload/attachments')
  UPLOAD_EXCEL = File.join(ROOT_PATH, '/upload/excels')
  WATER_MARK_PATH = Rails.env == 'development' ? Rails.root.to_s + '/public' : '/home/orchid/orchid_wine/current/public'

  PAGE_SIZE = 10
  ADMIN_PAGE_SIZE = 15
  ARTICLE_PAGE_SIZE = 8

  CONTAINER_TYPE = {
    1 => '40呎柜',
    2 => '20呎柜',
  }
  CONTAINER_VOLUME = {
    1 => 18000,
    2 => 14112
  }

  ORCHID_INFO = {
    :company_name => 'Orchid Wine Estate Pty Ltd',
    :company_address => '208 gouger street, Adelaide, SA 5000',
    :company_telephone => '+61 8 8410 4635',
    :company_contacts => 'Jonathon Li',
    :company_email => 'info@orchidwine.com.au',
    :company_abn => '69 163 686 128',
  }

  ORCHID_SHIPPER = {
    :company_name => 'Orchid Wine Estate Pty Ltd',
    :company_address => '208 gouger street, Adelaide, SA 5000',
    :company_telephone => '+61 8 8410 4635',
    :company_contacts => 'Lynn Song',
    :company_email => 'export@orchidwine.com.au',
    :company_abn => '69 163 686 128',
  }

  class << self
    def full_path(path)
      path = path.to_s.gsub(Const::ROOT_PATH.to_s, '')
      File.join(ROOT_PATH, path)
    end

    def relative_path(path)
      path = path.to_s.gsub(Const::ROOT_PATH.to_s, '')
    end
  end
end
