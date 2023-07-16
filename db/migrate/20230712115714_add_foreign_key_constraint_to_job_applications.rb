class AddForeignKeyConstraintToJobApplications < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :job_applications, :job_posts, on_delete: :cascade
  end
end

