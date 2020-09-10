# ActionMailer::Base.add_delivery_method :ses,
#                                        AWS::SES::Base,
#                                        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
#                                        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
#                                        server: 'email.ap-northeast-1.amazonaws.com'
creds = Aws::Credentials.new(
  ENV['AWS_ACCESS_KEY_ID'],
  ENV['AWS_SECRET_ACCESS_KEY']
)
Aws::Rails.add_action_mailer_delivery_method(:aws_sdk, credentials: creds, region: 'ap-northeast-1')
