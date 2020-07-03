class CreateAds < ActiveRecord::Migration[6.0]
  def change
    create_table :ads do |t|
      t.belongs_to(:event)
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
