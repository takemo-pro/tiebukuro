class AddSolvedToComments < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :solved, :boolean, default: false
  end
end
