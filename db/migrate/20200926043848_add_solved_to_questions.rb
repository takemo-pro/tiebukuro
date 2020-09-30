class AddSolvedToQuestions < ActiveRecord::Migration[6.0]
  def change
    add_column :questions, :solved, :boolean, default: false
  end
end
