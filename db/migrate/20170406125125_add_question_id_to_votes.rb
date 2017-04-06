class AddQuestionIdToVotes < ActiveRecord::Migration[5.0]
  def change
    add_belongs_to :votes, :question
  end
end
