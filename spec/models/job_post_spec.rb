require 'rails_helper'

RSpec.describe JobPost, type: :model do
  it { should belong_to(:user) }
  it { should have_many(:job_applications) }
  it { should have_many(:applicants).through(:job_applications) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
end