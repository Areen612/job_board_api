class JobPost < ApplicationRecord
  belongs_to :user
  has_many :job_applications
  has_many :applicants, through: :job_applications, source: :user
  validates :title, presence: true
  validates :description, presence: true
end
