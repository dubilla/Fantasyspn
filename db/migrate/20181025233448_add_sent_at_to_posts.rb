class AddSentAtToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :sent_at, :datetime, index: true
  end
end
