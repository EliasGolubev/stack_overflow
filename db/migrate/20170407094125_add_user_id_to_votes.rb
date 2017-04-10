class AddUserIdToVotes < ActiveRecord::Migration[5.0]
  def change
    add_belongs_to :votes, :user
  end
end
