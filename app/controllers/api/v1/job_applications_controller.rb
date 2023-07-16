class Api::V1::JobApplicationsController < ApplicationController
  before_action :authenticate_user!, except: [:create, :update]
  before_action :set_current_user, only: [:create]      
  before_action :set_job_application, only: [:show, :update, :destroy]
  load_and_authorize_resource

  def index
    job_applications = JobApplication.all
    render json: job_applications
  end

  def show
    if current_user.admin? && @job_application.status.blank? || @job_application.status == 'Not Seen'
      @job_application.update(status: 'Seen')
    end
  
    render json: @job_application.attributes.merge(status: @job_application.status)
  end   
  
  def create
    job_post = JobPost.find(params[:job_post_id])
    job_application = job_post.job_applications.build(job_application_params.merge(user_id: current_user.id, status: 'Not Seen'))
    
    if job_application.save
      job_post.applicants << current_user
      render json: job_application, status: :created
    else
      render json: { errors: job_application.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def update
    if @job_application.update(job_application_params)
      render json: @job_application
    else
      render json: { errors: @job_application.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    puts "inside destroy"
    puts "Authorization header: #{request.headers['Authorization']}"
    @job_application.destroy
    head :no_content
  end

  private

  def set_job_application
    @job_application = JobApplication.find(params[:id])
  end

  def job_application_params
    params.require(:job_application).permit(:job_post_id, :status)
  end
end
