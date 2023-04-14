OpenAI.configure do |config|
  config.access_token = Rails.application.credentials.open_ai.access_token
  config.organization_id = Rails.application.credentials.open_ai.organization_id
end
