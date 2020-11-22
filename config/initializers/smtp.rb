# frozen_string_literal: true

ActionMailer::Base.smtp_settings = {
  domain: Rails.application.credentials[:HOST_NAME],
  address: "smtp.sendgrid.net",
  port: 587,
  authentication: :plain,
  user_name: 'apikey',
  password: Rails.application.credentials[:SENDGRID_API_KEY],
}
