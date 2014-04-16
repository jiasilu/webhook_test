WebhookTest::Application.routes.draw do
  # API Routes
  namespace :api do
    post :sendgrid_webhooks, to: "emails#track"
  end
end
