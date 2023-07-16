class Api::V1::JobPostsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_job_post, only: [:show, :update, :destroy]

  def index
    job_posts = JobPost.all
    render json: job_posts
  end
  
  def show
    render json: @job_post
  end

  def create
    if current_user&.admin?
      job_post = current_user.job_posts.build(job_post_params)
      if job_post.save
        render json: job_post, status: :created
      else
        render json: { errors: job_post.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
    
  def update
    if @job_post.update(job_post_params)
      render json: @job_post
    else
      render json: { errors: @job_post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    puts "Authorization header: #{request.headers['Authorization']}"
    @job_post.destroy
    head :no_content
  end

  private

  def set_job_post
    @job_post = JobPost.find(params[:id])
  end

  def job_post_params
    params.require(:job_post).permit(:title, :description)
  end
end
