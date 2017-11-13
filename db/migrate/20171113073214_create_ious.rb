class CreateIous < ActiveRecord::Migration[5.1]
  def change
    create_table :ious do |t|
      t.integer :lender
      t.integer :debtor
      t.integer :amt

      t.timestamps
    end
  end
end
