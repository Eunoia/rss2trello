class AddListIdToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :list_id, :string
  end
end
