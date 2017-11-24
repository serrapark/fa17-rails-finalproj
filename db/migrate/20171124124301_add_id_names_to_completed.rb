class AddIdNamesToCompleted < ActiveRecord::Migration[5.1]
  def change
  	rename_column :completeds, :lender, :lender_id
  	rename_column :completeds, :debtor, :debtor_id
  end
end
