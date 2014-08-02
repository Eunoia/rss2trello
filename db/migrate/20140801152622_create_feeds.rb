class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string :name
      t.string :url
      t.integer :interval
      t.text :description
      t.datetime :last_retrived
      t.references :user
      t.timestamps
    end
  end
end
