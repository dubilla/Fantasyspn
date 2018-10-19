class AddIndexToPostsPublishedAt < ActiveRecord::Migration[5.2]
  def change
    add_index :posts, :published_at
  end
end
