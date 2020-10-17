class RemoveColumnContents < ActiveRecord::Migration[6.0]
  def change
    remove_column :comments, :content, :text
    remove_column :questions, :content, :text
  end
end
