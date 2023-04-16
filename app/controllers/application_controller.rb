class ApplicationController < ActionController::Base
  http_basic_authenticate_with(
    name: Rails.application.credentials.http_basic_auth.name,
    password: Rails.application.credentials.http_basic_auth.password
  )
end
