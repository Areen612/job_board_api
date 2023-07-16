class Api::V1::AuthenticationController < ApplicationController
  def authenticate
    email = params.dig('user', 'email')
    password = params.dig('user', 'password')

    puts "Params: #{params.inspect}"
    puts "Received authentication request for email: #{email}, password: #{password}"

    puts "Working Email: #{params.dig('user', 'email')}"

    user = User.find_by(email: email)
    puts "user: #{user}"

    if user&.authenticate(password)
      puts "User #{user.email} authenticated successfully"
      render json: { token: generate_token(user_id: user.id) }
    else
      puts "Failed to authenticate user with email: #{email} and password: #{password}"
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def logout
    token = request.headers['Authorization']&.split(' ')&.last
    if token_valid?(token)
      invalidate_token(token)
      puts "valid token"
      render json: { message: 'Logout successful' }
    else
      puts "invalid token"
      render json: { error: 'Invalid token' }, status: :unauthorized
    end
  end

  private

  def generate_token(payload)
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end

  def token_valid?(token)
    # Check if the token is present in the blacklist
    #!BlacklistedToken.exists?(token: token)
    true
  end

  def invalidate_token(token)
    # Add the token to the blacklist
    BlacklistedToken.create(token: token)
  end
end
