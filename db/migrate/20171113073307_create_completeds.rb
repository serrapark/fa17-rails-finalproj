class CreateCompleteds < ActiveRecord::Migration[5.1]
  def change
    create_table :completeds do |t|
      t.integer :lender
      t.integer :debtor
      t.integer :amt

      t.timestamps
    end
  end
end
