# frozen_string_literal: true

class SessionsController < Clearance::BaseController
  layout "sessions"

  before_action :redirect_signed_in_users, only: [:new]

  def create
    @user = authenticate(params)

    sign_in(@user) do |status|
      if status.success?
        redirect_back_or url_after_create
      else
        flash.now.alert = status.failure_message
        render template: "sessions/new", status: :unauthorized
      end
    end
  end

  def destroy
    sign_out
    redirect_to url_after_destroy, status: :see_other
  end

  def new
    render template: "sessions/new"
  end

  private

  def redirect_signed_in_users
    return unless signed_in?

    redirect_to url_for_signed_in_users
  end

  def url_after_create
    Clearance.configuration.redirect_url
  end

  def url_after_destroy
    sign_in_url
  end

  def url_for_signed_in_users
    url_after_create
  end
end
