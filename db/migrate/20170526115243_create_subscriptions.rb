class CreateSubscriptions < ActiveRecord::Migration[5.0]
  def change
    create_table :subscriptions do |t|
      t.belongs_to :user
      t.belongs_to :question
    end
    add_index :subscriptions, [:user_id, :question_id], unique: true
  end
end
