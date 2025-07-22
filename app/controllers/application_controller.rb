class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  # This disables CSRF protection only for requests with Content-Type: application/json — safe for APIs.
  protect_from_forgery unless: -> { request.format.json? }

  rescue_from StandardError do |e|
    render json: { error: e.message }, status: 500
  end

  rescue_from ActionController::InvalidAuthenticityToken do
    render json: { error: "Invalid CSRF token" }, status: 422
  end
end
