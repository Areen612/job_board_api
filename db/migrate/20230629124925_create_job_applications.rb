class CreateJobApplications < ActiveRecord::Migration[7.0]
  def change
    create_table :job_applications do |t|
      t.references :job_post, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :status, default: 'Not Seen'
      t.timestamps
    end
  end
end