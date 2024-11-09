require 'google/apis/gmail_v1'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'
require 'mail'

class GmailCpts

  OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'.freeze
  APPLICATION_NAME = 'Gmail API Ruby Quickstart'.freeze
  CLIENT_SECRETS_PATH = '/home/orchid/orchid_wine/shared/config/gmail/client_secret.json'.freeze
  CREDENTIALS_PATH = '/home/orchid/orchid_wine/shared/config/gmail/token.yaml'.freeze
  SCOPE = Google::Apis::GmailV1::AUTH_GMAIL_SEND

  class << self

    def authorize

      # client_id = Google::Auth::ClientId.from_file(CLIENT_SECRETS_PATH)
      # token_store = Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)
      # authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
      # user_id = 'default'
      # credentials = authorizer.get_credentials(user_id)
      # if credentials.nil?
      #   url = authorizer.get_authorization_url(base_url: OOB_URI)
      #   puts 'Open the following URL in the browser and enter the ' \
      #     'resulting code after authorization:\n' + url
      #   code = gets
      #   credentials = authorizer.get_and_store_credentials_from_code(
      #     user_id: user_id, code: code, base_url: OOB_URI
      #   )
      # end
      # credentials

      client_id = Google::Auth::ClientId.from_file(CLIENT_SECRETS_PATH)
      token_store = Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)
      authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)

      user_id = 'default'
      credentials = authorizer.get_credentials(user_id)

      if credentials.nil?
        code = '4/2AFLkBY9KYP2e1Jp1nhOL17JPReh1IReTrZ-m2jcOBPhU5wsbrFBNho'
        credentials = authorizer.get_and_store_credentials_from_code(
          user_id: user_id, code: code, base_url: OOB_URI
        )
      end

      credentials
    end

    def get_token_test
      service = Google::Apis::GmailV1::GmailService.new
      service.client_options.application_name = APPLICATION_NAME
      service.authorization = authorize

      'DONE'
      # user_id = 'me'
      # result = service.list_user_labels(user_id)
      # puts 'Labels:'
      # puts 'No labels found' if result.labels.empty?
      # result.labels.each { |label| puts "- #{label.name}" }
    end


    def send_mail(args, html)
      service = Google::Apis::GmailV1::GmailService.new
      service.client_options.application_name = APPLICATION_NAME
      service.authorization = authorize

      puts 'send_message START'
      message = Mail.new do
        from     args[:from]
        to       args[:to]
        cc       args[:cc]
        subject  args[:subject]

        html_part do
          content_type 'text/html; charset=UTF-8'
          body html
        end
      end

      service.send_user_message('me',
                                upload_source: StringIO.new(message.to_s),
                                content_type: 'message/rfc822')
      puts 'send_message END'
    end


    # -销售增加新订单后，发送邮件给指定销售以及管理员，发送(订单信息汇总表)预订单有效期保持三天。
    def order_new(order)
      subject = "预订单提交：PO-#{order.order_number}"
      message = "销售 #{order.seller.show_name} 提交了新的预订单。"
      deliver(subject, message, order)
    end

    # -预订单超期撤消。
    def order_cancel(order)
      subject = "预订单超期取消：PO-#{order.order_number}"
      message = "下单超过 14 天，已自动撤消到购物车。"
      deliver(subject, message, order)
    end

    # -修改完成后的订单，需要通过邮件系统，发送(订单汇总表，同⼀个订单号码-V2)
    def order_updated(order, admin)
      subject = "订单更新：PO-#{order.order_number}"
      message = "订单更新：#{admin.show_name} 更新了订单。"
      deliver(subject, message, order)
    end

    def deliver(subject, message, order)
      return unless File.exist?(self::CREDENTIALS_PATH)

      html = ApplicationController.new.render_to_string('/admin/orders/print', :layout => 'mail',
                                                        :locals => {
                                                          :@message => message,
                                                          :@order => order
                                                        }
                                                        )
      to = "#{order.seller.show_name}<#{order.seller.email}>"
      cc = Admin.cc_emails
      # to = 'Jason Zhao<jason.zhao@orchidwine.com.au>'
      # cc = 'Wu Yue<wuyueit@gmail.com>'

      args = {
        :from => 'WTS System<system@orchidwine.com.au>',
        :to => to,
        :cc => cc,
        # :to => 'Wu Yue<wuyueit@gmail.com>',
        # :cc => [],
        :subject => subject,
      }

      Rails.logger.info "GmailCpts send_mail -------------------------------------------------"
      Rails.logger.info args

      [
        Thread.new { GmailCpts.send_mail(args, html) },
      ].each &:join
    end
  end
end
