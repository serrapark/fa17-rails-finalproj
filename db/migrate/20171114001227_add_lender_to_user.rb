class AddLenderToUser < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :lender, foreign_key: true
  end
end
