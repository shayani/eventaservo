class AddLinksToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :about, :string
    add_column :users, :ligiloj, :jsonb, null: false, default: {}
  end
end
