class AddColumnBestToAnswer < ActiveRecord::Migration[5.0]
  def change
    add_column :answers, :best, :bool, null: false, default: false
  end
end
