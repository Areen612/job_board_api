class SessionsController < ApplicationController
  def create
    email = params.dig('user', 'email')
    password = params.dig('user', 'password')

    puts "Params: #{params.inspect}"
    puts "Received login request for email: #{email}"

    puts "Working Email: #{params.dig('user', 'email')}"

    # Find the user by email
    user = User.find_by(email: email)
    puts "user: #{user}"
    if user && user.authenticate(password)
      puts "User #{user.email} authenticated successfully"
      # Generate and return the authentication token
      token = JwtToken.encode(user_id: user.id)
      render json: { token: token }
    else
      puts "Failed to authenticate user with email: #{email}"
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end
end
