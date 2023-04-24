class ApplicationController < ActionController::Base
  before_action :set_chat_log

  http_basic_authenticate_with(
    name: Rails.application.credentials.http_basic_auth.name,
    password: Rails.application.credentials.http_basic_auth.password
  )

  def set_chat_log
    @chat_log = ChatLog.first_or_create!
  end
end
