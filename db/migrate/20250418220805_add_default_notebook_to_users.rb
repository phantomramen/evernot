class AddDefaultNotebookToUsers < ActiveRecord::Migration[8.0]
  def change
    add_reference :users, :default_notebook, foreign_key: { to_table: :notebooks }
  end
end
