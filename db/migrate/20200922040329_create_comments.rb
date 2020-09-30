class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.text :content
      t.references :user, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.timestamps
      t.references :parent, foreign_key:{ to_table: :comments} , optional: true
    end
  end
end
