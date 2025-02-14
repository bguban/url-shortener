class CreateUrls < ActiveRecord::Migration[7.2]
  def change
    create_table :urls do |t|
      t.string :slug, null: false
      t.text :url, null: false
      t.bigint :redirects_count, default: 0, null: false

      t.timestamps
    end
  end
end
