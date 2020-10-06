class AddPublicToParticipant < ActiveRecord::Migration[6.0]
  def change
    add_column :participants, :public, :boolean, default: false
    add_index :participants, :public
  end
end
