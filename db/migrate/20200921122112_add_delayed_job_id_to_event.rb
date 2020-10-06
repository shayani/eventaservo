class AddDelayedJobIdToEvent < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :delayed_job_id, :integer
  end
end
