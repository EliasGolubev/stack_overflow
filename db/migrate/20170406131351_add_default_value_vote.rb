class AddDefaultValueVote < ActiveRecord::Migration[5.0]
  def change
    change_column :votes, :vote, :boolean, null: false, default: false
  end
end
