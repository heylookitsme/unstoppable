class MyApplicationFailureApp < Devise::FailureApp
=begin
  def http_auth_body
    return super unless request_format == :json
    {
      success: false,
      message: i18n_message
    }.to_json
  end
=end
  def respond
    self.status = 401
    self.content_type = 'json'
    self.response_body = '{"error" : "authentication error"}'
  end
end