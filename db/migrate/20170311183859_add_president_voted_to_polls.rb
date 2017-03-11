class AddPresidentVotedToPolls < ActiveRecord::Migration[5.0]
  def change
    add_column :polls, :president_voted, :boolean, null: false, default: false
  end
end
