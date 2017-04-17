class AddUserIdToComments < ActiveRecord::Migration[5.0]
  def change
    add_belongs_to :comments, :user
  end
end
