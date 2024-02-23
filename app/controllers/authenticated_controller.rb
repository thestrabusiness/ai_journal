class AuthenticatedController < ApplicationController
  before_action :require_login
  before_action :set_chat_log

  def set_chat_log
    @chat_log = current_user.chat_logs.chat.first_or_create!
  end
end
