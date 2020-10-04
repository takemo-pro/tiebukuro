class AddReplyUserIdToComment < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :reply_user_id, :integer
    add_index :comments, :reply_user_id
  end
end
