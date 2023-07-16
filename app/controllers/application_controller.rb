class ApplicationController < ActionController::API
  before_action :authenticate_user!, except: [:create, :update]
  before_action :set_current_user

  def set_current_user
    token = request.headers['Authorization']&.split(' ')&.last
    puts "Token: #{token}"
    if token_valid?(token)
      decoded_token = decode_token(token)
      puts "Decoded token: #{decoded_token}"
      user_id = get_user_id(decoded_token)
      puts "User ID: #{user_id}" 
      @current_user = find_user(user_id)
      puts "Current User: #{@current_user}"
    else
      @current_user = nil
    end
  end

  def authenticate_user!
    token = request.headers['Authorization']&.split(' ')&.last
    puts "Authorization header: #{request.headers['Authorization']}"
    puts "Token: #{token}"
    render json: { error: 'Unauthorized' }, status: :unauthorized unless token_valid?(token)
  end

  def decode_token(token)
    token = token.split(' ').last # Remove the "Bearer" prefix
    puts "JWT Token: #{token}"
    decoded_token = JwtToken.decode(token)
    puts "JWT Decoded token: #{decoded_token}"
    decoded_token.present? ? decoded_token.first : {}
  end

  def token_valid?(token)
    JwtToken.decode(token).present?
  end

  protected

  def current_user
    @current_user ||= find_user(get_user_id(decode_token(request.headers['Authorization'])))
  end
end

def get_user_id(decoded_token)
  puts "Decoded token: #{decoded_token}"
  if decoded_token.is_a?(Array)
    user_id = decoded_token.second&.to_i
  else
    #user_id = decoded_token&.fetch('user_id', nil)&.to_i
    user_id = decoded_token&.first&.[]('user_id').to_i 
  end
  puts "User ID from decoded token: #{user_id}"
  user_id
end

def find_user(user_id)
  user = User.find_by(id: user_id)
  puts "User found: #{user.inspect}"
  user
end
