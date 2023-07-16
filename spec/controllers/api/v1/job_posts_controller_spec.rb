require 'rails_helper'

RSpec.describe Api::V1::JobPostsController, type: :controller do
  let(:admin_user) { create(:user, role: 'admin') }
  let(:job_post) { create(:job_post, user: admin_user) }

  describe 'GET #index' do
    it 'returns a list of job posts' do
      job_post1 = create(:job_post)
      job_post2 = create(:job_post)

      get :index

      expect(response).to have_http_status(:ok)
      expect(response_body).to eq([job_post1.as_json, job_post2.as_json])
    end
  end

  describe 'GET #show' do
    it 'returns the specified job post' do
      get :show, params: { id: job_post.id }

      expect(response).to have_http_status(:ok)
      expect(response_body).to eq(job_post.as_json)
    end
  end

  describe 'POST #create' do
    context 'when user is an admin' do
      let(:valid_params) do
        {
          job_post: {
            title: 'Software Engineer',
            description: 'We are looking for a skilled software engineer.'
          }
        }
      end

      before do
        request.headers['Authorization'] = "Bearer #{admin_user.generate_jwt}"
      end

      it 'creates a new job post' do
        expect {
          post :create, params: valid_params
        }.to change(JobPost, :count).by(1)
      end

      it 'returns a success response' do
        post :create, params: valid_params
        expect(response).to have_http_status(:created)
      end
    end

    context 'when user is not an admin' do
      let(:job_seeker_user) { create(:user, role: 'jobseeker') }
      let(:invalid_params) do
        {
          job_post: {
            title: 'Software Engineer',
            description: 'We are looking for a skilled software engineer.'
          }
        }
      end

      before do
        request.headers['Authorization'] = "Bearer #{job_seeker_user.generate_jwt}"
      end

      it 'does not create a new job post' do
        expect {
          post :create, params: invalid_params
        }.not_to change(JobPost, :count)
      end

      it 'returns an unauthorized response' do
        post :create, params: invalid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PATCH #update' do
    context 'when user is an admin' do
      let(:valid_params) do
        {
          id: job_post.id,
          job_post: {
            title: 'Updated Title',
            description: 'Updated Description'
          }
        }
      end

      before do
        request.headers['Authorization'] = "Bearer #{admin_user.generate_jwt}"
      end

      it 'updates the specified job post' do
        patch :update, params: valid_params

        job_post.reload

        expect(job_post.title).to eq('Updated Title')
        expect(job_post.description).to eq('Updated Description')
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
          id: job_post.id,
          job_post: {
            title: 'Updated Title',
            description: 'Updated Description'
          }
        }
      end

      before do
        request.headers['Authorization'] = "Bearer #{job_seeker_user.generate_jwt}"
      end

      it 'does not update the specified job post' do
        original_title = job_post.title

        patch :update, params: invalid_params

        job_post.reload

        expect(job_post.title).to eq(original_title)
        expect(job_post.description).not_to eq('Updated Description')
      end

      it 'returns an unauthorized response' do
        patch :update, params: invalid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is an admin' do
      before do
        request.headers['Authorization'] = "Bearer #{admin_user.generate_jwt}"
      end

      it 'destroys the specified job post' do
        expect {
          delete :destroy, params: { id: job_post.id }
        }.to change(JobPost, :count).by(-1)
      end

      it 'returns a no content response' do
        delete :destroy, params: { id: job_post.id }
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when user is not an admin' do
      let(:job_seeker_user) { create(:user, role: 'jobseeker') }

      before do
        request.headers['Authorization'] = "Bearer #{job_seeker_user.generate_jwt}"
      end

      it 'does not destroy the specified job post' do
        expect {
          delete :destroy, params: { id: job_post.id }
        }.not_to change(JobPost, :count)
      end

      it 'returns an unauthorized response' do
        delete :destroy, params: { id: job_post.id }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
