require 'rails_helper'

RSpec.describe Api::V1::JobApplicationsController, type: :controller do
  let(:admin_user) { create(:user, role: 'admin') }
  let(:job_post) { create(:job_post) }
  let(:job_application) { create(:job_application, job_post: job_post) }

  describe 'GET #index' do
    it 'returns a list of job applications' do
      job_application1 = create(:job_application)
      job_application2 = create(:job_application)

      get :index

      expect(response).to have_http_status(:ok)
      expect(response_body).to eq([job_application1.as_json, job_application2.as_json])
    end
  end

  describe 'GET #show' do
    context 'when status is blank or "Not Seen" for admin' do
      it 'updates the status to "Seen" for admin' do
        admin_user = create(:user, role: 'admin')
        job_application.update(status: 'Not Seen')

        request.headers['Authorization'] = "Bearer #{admin_user.generate_jwt}"

        get :show, params: { id: job_application.id }

        job_application.reload

        expect(job_application.status).to eq('Seen')
        expect(response).to have_http_status(:ok)
        expect(response_body['status']).to eq('Seen')
      end
    end

    context 'when status is not blank or "Not Seen" for admin' do
      it 'does not update the status for admin' do
        admin_user = create(:user, role: 'admin')
        job_application.update(status: 'Seen')

        request.headers['Authorization'] = "Bearer #{admin_user.generate_jwt}"

        get :show, params: { id: job_application.id }

        job_application.reload

        expect(job_application.status).to eq('Seen')
        expect(response).to have_http_status(:ok)
        expect(response_body['status']).to eq('Seen')
      end
    end

    context 'when user is not an admin' do
      it 'does not update the status' do
        job_seeker_user = create(:user, role: 'jobseeker')
        job_application.update(status: 'Not Seen')

        request.headers['Authorization'] = "Bearer #{job_seeker_user.generate_jwt}"

        get :show, params: { id: job_application.id }

        job_application.reload

        expect(job_application.status).to eq('Not Seen')
        expect(response).to have_http_status(:ok)
        expect(response_body['status']).to eq('Not Seen')
      end
    end
  end

  describe 'POST #create' do
    let(:job_seeker_user) { create(:user, role: 'jobseeker') }
    let(:valid_params) do
      {
        job_post_id: job_post.id,
        job_application: {
          status: 'Not Seen'
        }
      }
    end

    before do
      request.headers['Authorization'] = "Bearer #{job_seeker_user.generate_jwt}"
    end

    it 'creates a new job application' do
      expect {
        post :create, params: valid_params
      }.to change(JobApplication, :count).by(1)
    end

    it 'returns a success response' do
      post :create, params: valid_params
      expect(response).to have_http_status(:created)
    end
  end

  describe 'PATCH #update' do
    context 'when user is an admin' do
      let(:admin_user) { create(:user, role: 'admin') }
      let(:valid_params) do
        {
          id: job_application.id,
          job_application: {
            status: 'Approved'
          }
        }
      end

      before do
        request.headers['Authorization'] = "Bearer #{admin_user.generate_jwt}"
      end

      it 'updates the specified job application' do
        patch :update, params: valid_params

        job_application.reload

        expect(job_application.status).to eq('Approved')
        expect(response).to have_http_status(:ok)
      end

      it 'returns a success response' do
        patch :update, params: valid_params
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user is not an admin' do
      let(:job_seeker_user) { create(:user, role: 'jobseeker') }
      let(:invalid_params) do
        {
          id: job_application.id,
          job_application: {
            status: 'Approved'
          }
        }
      end

      before do
        request.headers['Authorization'] = "Bearer #{job_seeker_user.generate_jwt}"
      end

      it 'does not update the specified job application' do
        original_status = job_application.status

        patch :update, params: invalid_params

        job_application.reload

        expect(job_application.status).to eq(original_status)
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns an unauthorized response' do
        patch :update, params: invalid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is an admin' do
      let(:admin_user) { create(:user, role: 'admin') }

      before do
        request.headers['Authorization'] = "Bearer #{admin_user.generate_jwt}"
      end

      it 'destroys the specified job application' do
        expect {
          delete :destroy, params: { id: job_application.id }
        }.to change(JobApplication, :count).by(-1)
      end

      it 'returns a no content response' do
        delete :destroy, params: { id: job_application.id }
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when user is not an admin' do
      let(:job_seeker_user) { create(:user, role: 'jobseeker') }

      before do
        request.headers['Authorization'] = "Bearer #{job_seeker_user.generate_jwt}"
      end

      it 'does not destroy the specified job application' do
        expect {
          delete :destroy, params: { id: job_application.id }
        }.not_to change(JobApplication, :count)
      end

      it 'returns an unauthorized response' do
        delete :destroy, params: { id: job_application.id }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
