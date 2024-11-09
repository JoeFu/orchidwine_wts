require 'google/apis/gmail_v1'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'
require 'rmail'

OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'.freeze
APPLICATION_NAME = 'Gmail API Ruby Quickstart'.freeze
CLIENT_SECRETS_PATH = 'client_secret.json'.freeze
CREDENTIALS_PATH = 'token.yaml'.freeze
SCOPE = Google::Apis::GmailV1::AUTH_GMAIL_SEND

def authorize
  client_id = Google::Auth::ClientId.from_file(CLIENT_SECRETS_PATH)
  token_store = Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)
  authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
  user_id = 'default'
  credentials = authorizer.get_credentials(user_id)

  if credentials.nil?
    code = '4/AABr2_rkjAmrlJzei2Z3yVbrq_yrrurrfajDBKqcjuv5Tp6E5lsGAcg'
    credentials = authorizer.get_and_store_credentials_from_code(
      user_id: user_id, code: code, base_url: OOB_URI
    )
  end

  credentials
end

service = Google::Apis::GmailV1::GmailService.new
service.client_options.application_name = APPLICATION_NAME
service.authorization = authorize

puts 'send_message START'
options = {
  :to => 'wuyue@techjumper.com',
  :from => 'wuyueit@gmail.com',
  :subject => 'Test Subject',
  :body => 'content message.'
}

# message = RMail::Message.new
# message.header['To'] = options[:to]
# message.header['From'] = options[:from]
# message.header['Subject'] = options[:subject]
# message.body = MIMEText(options[:body],'html')

message = Mail.new do
  from     'system@orchidwine.com.au'
  to       'wuyue@techjumper.com'
  subject  'Test Subject'

  html_part do
    content_type 'text/html; charset=UTF-8'
    body '<h1>This is HTML</h1><br/>line 2'
  end
end


service.send_user_message('me',
                          upload_source: StringIO.new(message.to_s),
                          content_type: 'message/rfc822')
puts 'send_message END'
