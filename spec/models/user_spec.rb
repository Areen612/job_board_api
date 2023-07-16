require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_secure_password }
  it { should have_many(:job_posts) }
  it { should have_many(:job_applications) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of(:password_digest) }

  describe '#admin?' do
    let(:user) { User.new(role: 'admin') }

    it 'returns true if the user is an admin' do
      expect(user.admin?).to be true
    end

    it 'returns false if the user is not an admin' do
      user.role = 'jobseeker'
      expect(user.admin?).to be false
    end
  end

  describe '#job_seeker?' do
    let(:user) { User.new(role: 'jobseeker') }

    it 'returns true if the user is a job seeker' do
      expect(user.job_seeker?).to be true
    end

    it 'returns false if the user is not a job seeker' do
      user.role = 'admin'
      expect(user.job_seeker?).to be false
    end
  end
end
