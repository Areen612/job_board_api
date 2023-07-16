require 'rails_helper'

RSpec.describe JobApplication, type: :model do
  it { should belong_to(:job_post) }
  it { should belong_to(:user) }
end
