class ImproveProfile < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :instruo, :jsonb, null: false, default: {}
    add_column :users, :prelego, :jsonb, null: false, default: {}
  end
end
