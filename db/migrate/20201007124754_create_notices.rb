class CreateNotices < ActiveRecord::Migration[6.0]
  def change
    create_table :notices do |t|
      t.integer :visiter_id
      t.integer :visited_id
      t.integer :question_id
      t.integer :comment_id
      t.string :action
      t.boolean :checked,default: false,null:false

      t.timestamps
    end
  end
end
